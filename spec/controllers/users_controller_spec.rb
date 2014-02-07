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

    context "with valid input" do
      before do
        post :create, user: user_hash
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
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
      after { ActionMailer::Base.deliveries.clear }

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

  describe "POST email_password_token" do
    context "with a exists email address" do
      let(:user) { Fabricate(:user) }

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "redirects to confirm password reset page" do
        post :email_password_token, email: user.email
        expect(response).to redirect_to confirm_password_reset_path
      end

      it "creates a password reset record" do
        post :email_password_token, email: user.email
        expect(PasswordReset.count).to eq(1)
      end

      it "sends out a email to the email address" do
        post :email_password_token, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it "sends out a email containing a url with password reset token" do
        post :email_password_token, email: user.email
        url = reset_password_path(user.live_password_token)
        expect(ActionMailer::Base.deliveries.last.body).to include(url)
      end
    end

    context "with a not exists email address" do
      let(:user) { Fabricate(:user) }
      let(:incorrect_email) { "#{user.email}test" }

      it "redirects to the forgot password page" do
        post :email_password_token, email: incorrect_email
        expect(response).to redirect_to forgot_password_path
      end

      it "does not create a password reset record" do
        post :email_password_token, email: incorrect_email
        expect(PasswordReset.count).to eq(0)
      end

      it "does not send out email" do
        post :email_password_token, email: incorrect_email
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash[:alert] message" do
        post :email_password_token, email: incorrect_email
        expect(flash[:alert]).not_to be_blank
      end
    end
  end
end