ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "./test/helpers/authentication_helper"

def ci?
  ENV["CI"] == "true"
end

module SignInHelper
  def sign_in
    user = User.find_by!(role: "principal")
    post session_url, params: { email_address: user.email_address, password: "password123" }
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: 8)

    # Ensure test DB is seeded before running tests
    setup do
      Rails.application.load_seed unless User.exists?
    end
  end
end
