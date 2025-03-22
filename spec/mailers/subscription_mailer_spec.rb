# spec/mailers/subscription_mailer_spec.rb
require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  include FactoryBot::Syntax::Methods

  describe "reminder_email" do
    let(:user) { create(:user) }
    let(:mail) { SubscriptionMailer.reminder_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Subscription Renewal Reminder")
      expect(mail.to).to eq([ user.email_address ])
      expect(mail.from).to eq([ "smarteduccc@gmail.com" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(/Dear/)
    end
  end
end
