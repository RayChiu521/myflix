require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user to a new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    let(:user_hash) { Fabricate.attributes_for(:user) }

    after { ActionMailer::Base.deliveries.clear }

    context "with valid input" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "creates the user" do
        post :create, user: user_hash
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        post :create, user: user_hash
        expect(response).to redirect_to sign_in_path
      end

      context "with invitation" do
        let(:monica) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, invitor: monica, recipient_email: user_hash[:email]) }

        it "makes the user follow the invitor" do
          post :create, user: user_hash, invitation_token: invitation.token
          expect(assigns(:user).reload.followed?(monica)).to be_true
        end

        it "makes the invitor follow the user" do
          post :create, user: user_hash, invitation_token: invitation.token
          expect(monica.followed?(assigns(:user))).to be_true
        end

        it "expires the invitation upon accpetance" do
          post :create, user: user_hash, invitation_token: invitation.token
          expect(invitation.reload.token).to be_nil
        end
      end
    end

    context "with invalid input" do
      before do
        user_hash[:email] = nil
        post :create, user: user_hash
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets the @user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context "mail sending" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "sends out the mail to the user with valid inputs" do
        post :create, user: user_hash
        expect(ActionMailer::Base.deliveries.last.to).to eq([user_hash[:email]])
      end

      it "sends out the email containing the user's name with valid inputs" do
        post :create, user: user_hash
        expect(ActionMailer::Base.deliveries.last.body).to include(user_hash[:full_name])
      end

      it "does not send out email with invalid inputs" do
        user_hash[:email] = nil
        post :create, user: user_hash
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    before do
      set_current_user
    end

    it "sets the @user variable" do
      get :show, id: get_current_user.id
      expect(assigns(:user)).to eq(get_current_user)
    end

    it_should_behave_like "require sign in" do
      let(:action) { get :show, id: 1 }
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @users with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to the expired token page for invalid token" do
      get :new_with_invitation_token, token: "invalid_token"
      expect(response).to redirect_to expired_token_path
    end
  end
end