class PaymentMailer < ApplicationMailer
  default from: "smarteduccc@gmail.com"

  def receipt_email(payment)
    @payment = payment
    mail(to: @payment.user.personal_email, subject: "Payment Receipt")
  end
end
