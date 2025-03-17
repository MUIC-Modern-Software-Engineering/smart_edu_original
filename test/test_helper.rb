ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "./test/helpers/authentication_helper"
require "minitest/mock"

def ci?
  ENV["CI"] == "true"
end

module SignInHelper
  def sign_in
    user = User.find_by!(role: "principal")
    post session_path, params: { email_address: user.email_address, password: "password123", school_id: user.school_id }
    follow_redirect!
    assert_response :success, "Login failed: #{response.body}"
  end

  def sign_in_with_parameter(user)
    post session_path, params: { email_address: user.email_address, password: user.password, school_id: user.school_id }
    follow_redirect!
    assert_response :success, "Login failed: #{response.body}"
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: 4)

    # Ensure test DB is seeded before running tests
    setup do
      ensure_school_exists
      Rails.application.load_seed unless User.exists?
    end

    private

    def ensure_school_exists
      # Create a default test school if none exists
      @test_school ||= School.first || School.create!(name: "Test School", address: "123 Test St")

      # Ensure ALL test users (newly created or existing) have a school
      User.where(school_id: nil).find_each do |user|
        user.update!(school_id: @test_school.id)
      end
    end
  end
end
