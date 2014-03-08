require "spec_helper"

describe "Stripe charges failed" do
  let(:event_data) do
    {
      "id" => "evt_103d2b2Gp7PcNcb0NEsZkKf7",
      "created" => 1394293099,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_103d2b2Gp7PcNcb0uuXGRvfG",
          "object" => "charge",
          "created" => 1394293099,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103d2b2Gp7PcNcb0R29OCeod",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 3,
            "exp_year" => 2017,
            "fingerprint" => "WftsqOXnyzpRpWcL",
            "customer" => "cus_3d16htYWNGpMVw",
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
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_3d16htYWNGpMVw",
          "invoice" => nil,
          "description" => "payment to failed",
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3d2bZxXgaXAaHg"
    }
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  it "deactivates a user", :vcr do
    monica = Fabricate(:user, stripe_customer_id: "cus_3d16htYWNGpMVw")
    post stripe_event_path, event_data
    expect(monica.reload).not_to be_active
  end

  it "should send out email", :vcr do
    monica = Fabricate(:user, stripe_customer_id: "cus_3d16htYWNGpMVw")
    post stripe_event_path, event_data
    expect(ActionMailer::Base.deliveries.last.to).to eq([monica.email])
  end
end