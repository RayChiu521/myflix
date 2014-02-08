require "spec_helper"

describe PasswordResetsController do
  describe "GET show" do
    let(:user) { Fabricate(:user) }
    before { user.generate_password_reset_token }

    it "renders the :show template with valid token" do
      get :show, id: user.live_password_token
      expect(response).to render_template :show
    end

    it "redirects to invalid token page with invalid token" do
      get :show, id: "test#{user.live_password_token}"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user, password: "old_password") }
    let(:token) do
      user.generate_password_reset_token
      user.live_password_token
    end

    context "with a valid password" do

      it "redirects to the sign in page" do
        post :create, token: token,password: "new_password"
        expect(response).to redirect_to sign_in_path
      end

      it "updates user's password" do
        post :create, token: token, password: "new_password"
        expect(user.reload.authenticate("new_password")).to be_true
      end

      it "sets the flash[:notice] message" do
        post :create, token: token, password: "new_password"
        expect(flash[:notice]).to be_present
      end
    end

    context "with a invalid password" do
      it "redirects to the reset password page" do
        post :create, token: token, password: ""
        expect(response).to redirect_to password_reset_path(token)
      end

      it "does not update users password_digest" do
        post :create, token: token, password: ""
        expect(user.reload.authenticate("old_password")).to be_true
      end

      it "sets the flash[:alert] message" do
        post :create, token: token, password: ""
        expect(flash[:alert]).to be_present
      end
    end
  end
end