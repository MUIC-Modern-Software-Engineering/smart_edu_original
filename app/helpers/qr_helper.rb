module QrHelper
  require "rqrcode"

  def generate_qr_code(student)
    user = User.find_by(email_address: student.student_email_address)

    if user.nil?
      Rails.logger.error("No user found for student email: #{student.student_email_address}")
      return nil
    end

    qr_data = "#{student.id}|#{user.school_id}"

    qr = RQRCode::QRCode.new(qr_data)
    qr.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    ).html_safe
  end
end
