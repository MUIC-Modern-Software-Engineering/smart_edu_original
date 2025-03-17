class PaymentsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_principal, only: [ :create, :success ]
  def create
    Rails.logger.debug("Received params: #{params.inspect}")

    first_name = params[:first_name]
    last_name = params[:last_name]
    amount = params[:amount].to_i
    payment_method_id = params[:payment_method_id]

    Rails.logger.info("Current user is: #{current_user.inspect}")
    begin
      payment_intent = Stripe::PaymentIntent.create({
                                                      amount: amount * 100,
                                                      currency: "thb",
                                                      payment_method: payment_method_id,
                                                      confirmation_method: "manual",
                                                      confirm: true,
                                                      return_url: success_payments_url
                                                    })

      payment = Payment.create(
        amount: amount,
        status: "succeeded",
        user_id: current_user.id,
        stripe_payment_intent_id: payment_intent.id,
        last_name: last_name,
        first_name: first_name
      )
      session[:last_payment_id] = payment.id

      # current user information


      Rails.logger.info("Payment intent: #{payment_intent}")
      Rails.logger.info("Payment: #{payment}")


      PaymentMailer.receipt_email(payment).deliver_later

      # redirect_to success_payments_url

      Rails.logger.info("Received payment: #{@payment}")

      # update the school table to be paid
      school = School.find_by(id: current_user.school_id)
      school.update(has_paid: 1)


      render json: { status: "success", payment: payment }, status: 200

    rescue Stripe::StripeError => e
      Rails.logger.error("Stripe error: #{e.message}")
      render json: { error: e.message }, status: 500
    rescue StandardError => e
      Rails.logger.error("General error: #{e.message}")
      render json: { error: e.message }, status: 500
    end
  end

  def success
    @payment = Payment.find_by(id: session[:last_payment_id])
    # Clear the session variable after using it
    session.delete(:last_payment_id)
  end

  def cancel
    redirect_to root_path, alert: "Payment cancelled."
  end

  private
  def check_principal
    redirect_to root_path, alert: "Unauthorized access" unless current_user&.principal?
  end

  def payment_params
    params.require(:payment).permit(:first_name, :last_name, :amount, :stripe_payment_intent_id, :user_id)
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "You need to sign in before continuing." unless current_user
  end
end
