require "spec_helper"

describe "Stripe charges successfully" do
  let(:event_data) do
    {
      "id" => "evt_103d062Gp7PcNcb03vujQxzQ",
      "created" => 1394283784,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_103d062Gp7PcNcb01QsC3Npe",
          "object" => "charge",
          "created" => 1394283784,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103d062Gp7PcNcb0RsMvP1nu",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 3,
            "exp_year" => 2015,
            "fingerprint" => "vjnC1BDDDni6vY6s",
            "customer" => "cus_3d066us3jDQBTc",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_103d062Gp7PcNcb0QWbYKSWA",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_3d066us3jDQBTc",
          "invoice" => "in_103d062Gp7PcNcb0i8z7WfBL",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3d06jhTGDKHnfe"
    }
  end

  it "creates a payment", :vcr do
    post stripe_event_path, event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    monica = Fabricate(:user, stripe_customer_id: 'cus_3d066us3jDQBTc')
    post stripe_event_path, event_data
    expect(Payment.last.user).to eq(monica)
  end

  it "creates the payment with the amount", :vcr do
    post stripe_event_path, event_data
    expect(Payment.last.amount).to eq(999)
  end

  it "creates the payment with the reference id", :vcr do
    post stripe_event_path, event_data
    expect(Payment.last.reference_id).to eq('ch_103d062Gp7PcNcb01QsC3Npe')
  end

end