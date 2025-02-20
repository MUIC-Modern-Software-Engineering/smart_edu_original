class ApplicationController < ActionController::Base
  include Authentication
  helper :qr

  before_action :set_current_user

  private

  def set_current_user
    if Current.session
      @current_user = Current.session.user
      Rails.logger.info "DEBUG: Current user = #{@current_user&.email_address}"
    else
      Rails.logger.info "DEBUG: No active session"
    end
  end

  helper_method :current_user

  def current_user
    @current_user
  end
end
