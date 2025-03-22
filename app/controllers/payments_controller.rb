class PaymentsController < ApplicationController
  allow_unauthenticated_access only: %i[new create success cancel]

  def new
    @user = User.new
  end

  def create
    log_incoming_params
    disable_login_credentials_callback

    ActiveRecord::Base.transaction do
      school = create_school
      @user = find_or_create_user(school)
      payment = process_payment(@user)

      setup_session(payment, @user)
      send_receipt(payment)

      render json: { status: "success", payment: payment }, status: 200
    end

    send_credentials_email if @user&.persisted?
    enable_login_credentials_callback

  rescue Stripe::StripeError => e
    handle_stripe_error(e)
  rescue ActiveRecord::RecordInvalid => e
    handle_record_invalid(e)
  end

  def success
    @payment = Payment.find_by(id: session[:last_payment_id])
    session.delete(:last_payment_id) # Clear session after retrieving payment
  end

  def cancel
    redirect_to root_path, alert: "Payment cancelled."
  end

  private

  def log_incoming_params
    Rails.logger.debug("Received params from payment first page: #{params.inspect}")
    Rails.logger.debug("Received params unsafe: #{params.to_unsafe_h}")
  end

  def disable_login_credentials_callback
    User.skip_callback(:create, :after, :send_login_credentials) if User._create_callbacks.map(&:filter).include?(:send_login_credentials)
  end

  def enable_login_credentials_callback
    User.set_callback(:create, :after, :send_login_credentials) if User.method_defined?(:send_login_credentials)
  end

  def create_school
    school = School.find_or_create_by(name: params[:school_name]) do |s|
      s.address = params[:schoolAddress]
      s.has_paid = 1
    end

    Rails.logger.debug("School found or created: #{school.inspect}")
    school
  end

  def find_or_create_user(school)
    existing_user = User.find_by(personal_email: params[:email])

    if existing_user
      update_existing_user(existing_user)
    else
      create_new_user(school)
    end
  end

  def update_existing_user(user)
    user.update!(approved: true)
    Rails.logger.info("Existing user updated: #{user.inspect}")
    user
  end

  def create_new_user(school)
    user = User.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      personal_email: params[:email],
      role: "admin",
      school_id: school.id,
      approved: true
    )

    unless user.save
      Rails.logger.error("User creation failed: #{user.errors.full_messages.join(', ')}")
      raise ActiveRecord::RecordInvalid.new(user)
    end

    Rails.logger.info("New user created with ID: #{user.id}")
    user
  end

  def process_payment(user)
    payment_intent = create_stripe_payment_intent

    Payment.create!(
      amount: params[:amount].to_i,
      status: "succeeded",
      user_id: user.id,
      stripe_payment_intent_id: payment_intent.id,
      last_name: params[:last_name],
      first_name: params[:first_name],
      email: params[:email],
      subscription_start: Time.zone.now,
      subscription_end: Time.zone.now + 1.year
    )
  end

  def create_stripe_payment_intent
    Stripe::PaymentIntent.create({
                                   amount: params[:amount].to_i * 100,
                                   currency: "thb",
                                   payment_method: params[:payment_method_id],
                                   confirmation_method: "manual",
                                   confirm: true,
                                   return_url: success_payments_url
                                 })
  end

  def setup_session(payment, user)
    session[:last_payment_id] = payment.id
    start_new_session_for user
  end

  def send_receipt(payment)
    PaymentMailer.receipt_email(payment).deliver_now
  end

  def send_credentials_email
    password = @user.instance_variable_get(:@plain_password)
    UserMailer.send_login_credentials(@user, password).deliver_now if password
  end

  def handle_stripe_error(error)
    Rails.logger.error("Stripe error: #{error.message}")
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def handle_record_invalid(error)
    Rails.logger.error("ActiveRecord exception: #{error.message}")
    flash[:error] = "Error: #{error.message}"
    render :new, status: :unprocessable_entity
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_method_id, :email, :first_name, :last_name)
  end

  def user_params
    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      personal_email: params[:email],
      role: "admin"
    }
  end
end
