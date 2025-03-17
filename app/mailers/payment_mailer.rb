class PaymentMailer < ApplicationMailer
  default from: "smarteduccc@gmail.com"

  def receipt_email(payment)
    @payment = payment
    mail(to: @payment.user.email_address, subject: "Payment Receipt")
  end
end
