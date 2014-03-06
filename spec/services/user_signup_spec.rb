require "spec_helper"

describe UserSignup do

  let(:monica) { Fabricate(:user) }
  let(:new_user) { Fabricate.build(:user) }

  context "with valid user data and valid credit card" do
    let(:subscription) { double(:subscription, successful?: true, id: 'stripe custome id') }

    before do
      StripeWrapper::Customer.should_receive(:create).and_return(subscription)
    end

    after { ActionMailer::Base.deliveries.clear }

    it "should receive StripeWrapper::Customer.create" do
      UserSignup.new(new_user).sign_up("stripe_token")
    end

    it "creates the user" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(User.count).to eq(1)
    end

    it "sends out the mail to the user with valid inputs" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(ActionMailer::Base.deliveries.last.to).to eq([new_user.email])
    end

    it "sends out the email containing the user's name with valid inputs" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(ActionMailer::Base.deliveries.last.body).to include(new_user.full_name)
    end

    it "sets stripe customer id to user" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(User.last.stripe_customer_id).to be_present
    end

    context "with invitation" do
      let(:invitation) { Fabricate(:invitation, invitor: monica, recipient_email: new_user.email) }

      before do
        UserSignup.new(new_user).sign_up("stripe_token", invitation.token)
      end

      it "makes the user follow the invitor" do
        expect(new_user.reload.followed?(monica)).to be_true
      end

      it "makes the invitor follow the user" do
        expect(monica.followed?(new_user)).to be_true
      end

      it "expires the invitation upon accpetance" do
        expect(invitation.reload.token).to be_nil
      end
    end
  end

  context "with valid user data but invalid credit card" do
    before do
      subscription = double(:subscription, successful?: false, failure_message: 'Your card was declined')
      StripeWrapper::Customer.should_receive(:create).and_return(subscription)
    end

    it "should receive StripeWrapper::Customer.create" do
      UserSignup.new(new_user).sign_up("stripe_token")
    end

    it "does not create a user" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(User.count).to eq(0)
    end
  end

  context "with invalid user data" do
    before do
      new_user.email = nil
      StripeWrapper::Customer.should_not_receive(:create)
    end

    it "should not receive StripeWrapper::Customer.create" do
      UserSignup.new(new_user).sign_up("stripe_token")
    end

    it "does not create the user" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(User.count).to eq(0)
    end

    it "does not send out email with invalid inputs" do
      UserSignup.new(new_user).sign_up("stripe_token")
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end