ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "./test/helpers/authentication_helper"

def ci?
  ENV["CI"] == "true"
end

module SignInHelper
  def sign_in
    @school = School.create!(name: "Test School", address: "123 Test St")
    user = User.find_by!(role: "principal")
    post session_url, params: { email_address: user.email_address, password: "password123", school_id: @school.id }
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
