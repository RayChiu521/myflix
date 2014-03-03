require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user to a new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do

    let(:new_user) { Fabricate.attributes_for(:user) }

    context "successful user sign up" do
      it "redirects to the sign in page" do
        userSignup = double(:user_sign_up, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(userSignup)
        post :create, user: new_user
        expect(response).to redirect_to sign_in_path
      end
    end

    context "failed user sign up" do
      before do
        userSignup = double(:user_sign_up, successful?: false, error_message: "An error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(userSignup)
        post :create, user: new_user
      end

      it "renders the :new template" do
        expect(response).to render_template(:new)
      end

      it "sets the @user" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "sets flash alert message" do
        expect(flash.now[:alert]).to be_present
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