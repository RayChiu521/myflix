require 'spec_helper'

describe StripeWrapper do

  let(:valid_card_token) do
    Stripe::Token.create(
      :card => {
        :number => '4242424242424242',
        :exp_month => 2,
        :exp_year => (DateTime.now + 1.year).year,
        :cvc => '314'
      },
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => '4000000000000002',
        :exp_month => 2,
        :exp_year => (DateTime.now + 1.year).year,
        :cvc => '314'
      },
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do

      context "with valid card" do
        it "makes a successful charge", :vcr do
          charge = StripeWrapper::Charge.create(amount: 1000, card: valid_card_token)
          expect(charge.successful?).to be_true
        end
      end

      context "with invalid card" do
        subject { StripeWrapper::Charge.create(amount: 1000, card: declined_card_token) }

        it "does not charge successfully", :vcr do
          expect(subject.successful?).to be_false
        end

        it "has failure message", :vcr do
          expect(subject.failure_message).to be_present
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do

      let(:monica) { Fabricate(:user)}

      context "with valid card", :vcr do
        subject { StripeWrapper::Customer.create(card: valid_card_token, user: monica) }

        it { should be_successful }

        it "returns customer id from stripe" do
          expect(subject.id).to be_present
        end
      end

      context "with invalid card", :vcr do
        subject { StripeWrapper::Customer.create(card: declined_card_token, user: monica) }

        it { should_not be_successful }

        it "has failure message" do
          expect(subject.failure_message).to be_present
        end

        it "does not return customer id" do
          expect(subject.id).to be_nil
        end
      end
    end
  end
end