require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      before do
        StripeWrapper.set_api_key
      end
      let(:token) do
        Stripe::Token.create(
          :card => {
            :number => card_number,
            :exp_month => 2,
            :exp_year => (DateTime.now + 1.year).year,
            :cvc => "314"
          },
        ).id
      end

      context "with valid card" do
        let(:card_number) { "4242424242424242" }

        it "makes a successful charge", :vcr do
          charge = StripeWrapper::Charge.create(amount: 1000, card: token)
          expect(charge.successful?).to be_true
        end
      end

      context "with invalid card" do
        let(:card_number) { "4000000000000002" }
        let(:charge) { StripeWrapper::Charge.create(amount: 1000, card: token) }

        it "does not charge successfully", :vcr do
          expect(charge.successful?).to be_false
        end

        it "has failure message", :vcr do
          expect(charge.failure_message).to be_present
        end
      end
    end
  end
end