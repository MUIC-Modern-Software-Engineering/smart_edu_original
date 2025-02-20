class AdminController < ApplicationController
  before_action :require_admin

  def scan_qr
    # This will render app/views/admin/scan_qr.html.erb
  end

def checkin
  uid = params[:uid]
  hash = params[:hash]

  secret = Rails.application.credentials.secret_key_base
  expected = Digest::SHA256.hexdigest("#{uid}|#{secret}")

  if hash != expected
    render json: { success: false, message: "Invalid QR code" }
    return
  end

  student = Student.find_by(uid: uid)
  if student
    CheckinService.checkin(student, current_user)
    message = "Student checked in successfully at #{Time.current.strftime('%H:%M:%S')}."
    respond_to do |format|
      format.json { render json: { success: true, message: message } }
      format.html { redirect_to admin_scan_qr_path, notice: message }
    end
  else
    message = "Student not found."
    respond_to do |format|
      format.json { render json: { success: false, message: message } }
      format.html { redirect_to admin_scan_qr_path, alert: message }
    end
  end
end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
