module QrHelper
  require "rqrcode"
  require "digest"

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def generate_qr_code(uid)
    security_hash = Digest::SHA256.hexdigest("#{uid}|#{SECRET_KEY}")
    qr_data = "#{uid},#{security_hash}"

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
