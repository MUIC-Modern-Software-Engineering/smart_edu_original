# test/controllers/payments_controller_test.rb
require "test_helper"
require "stripe"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end

  test "should create payment" do
    payment_intent = Stripe::PaymentIntent.construct_from({
                                                            id: "pi_123",
                                                            amount: 1000,
                                                            currency: "thb",
                                                            status: "succeeded"
                                                          })

    Stripe::PaymentIntent.stub(:create, payment_intent) do
      sign_in

      payment_params = {
        first_name: "John",
        last_name: "Doe",
        amount: 10,
        payment_method_id: "pm_card_visa"
      }

      post payments_url, params: payment_params

      assert_response :success
      assert_equal "success", JSON.parse(response.body)["status"]
    end
  end

  test "should handle Stripe error" do
    # Stub Stripe::PaymentIntent.create to raise a Stripe error.
    Stripe::PaymentIntent.stub(:create, proc { |*_args| raise Stripe::StripeError.new("Stripe error occurred") }) do
      sign_in

      payment_params = {
        first_name: "Jane",
        last_name: "Doe",
        amount: 20,
        payment_method_id: "pm_card_visa"
      }

      post payments_url, params: payment_params

      assert_response 500
      assert_includes JSON.parse(response.body)["error"], "Stripe error occurred"
    end
  end

  test "should handle general error" do
    # Stub Stripe::PaymentIntent.create to raise a generic StandardError.
    Stripe::PaymentIntent.stub(:create, proc { |*_args| raise StandardError.new("General error occurred") }) do
      sign_in

      payment_params = {
        first_name: "Alice",
        last_name: "Smith",
        amount: 30,
        payment_method_id: "pm_card_visa"
      }

      post payments_url, params: payment_params

      assert_response 500
      assert_includes JSON.parse(response.body)["error"], "General error occurred"
    end
  end

  test "should render success page" do
    sign_in

    get success_payments_url
    assert_response :success
  end
end
