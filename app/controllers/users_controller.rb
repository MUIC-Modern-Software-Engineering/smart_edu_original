class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @pending_users = User.where(approved: false)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def approve
    @user = User.find(params[:id])

    if @user.update(approved: true)
      respond_to do |format|
        format.html { redirect_to users_path, notice: "#{@user.email_address} has been approved." }
        format.js
      end
    else
      Rails.logger.error "ERROR: Failed to approve user: #{@user.errors.full_messages.join(', ')}"
      respond_to do |format|
        format.html { redirect_to users_path, alert: "Failed to approve user." }
        format.js { render js: "alert('Failed to approve user: #{@user.errors.full_messages.join(', ')}')" }
      end
    end
  end

  def cancel
    @user = User.find(params[:id])

    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: "#{@user.email_address} has been removed." }
        format.js
      end
    else
      Rails.logger.error "ERROR: Failed to remove user: #{@user.errors.full_messages.join(', ')}"
      respond_to do |format|
        format.html { redirect_to users_path, alert: "Failed to remove user." }
        format.js { render js: "alert('Failed to remove user: #{@user.errors.full_messages.join(', ')}')" }
      end
    end
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.can_manage_teachers?
  end
end
