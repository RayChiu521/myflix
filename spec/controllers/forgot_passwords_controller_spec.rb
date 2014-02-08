require "spec_helper"

describe ForgotPasswordsController do
  describe "POST create" do
    after do
      ActionMailer::Base.deliveries.clear
    end

    context "with a exists email address" do
      let(:user) { Fabricate(:user) }

      it "redirects to forgot password confirmation page" do
        post :create, email: user.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "creates a reset password token" do
        post :create, email: user.email
        expect(ResetPasswordToken.count).to eq(1)
      end

      it "sends out a email to the email address" do
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it "sends out a email containing a url with password reset token" do
        post :create, email: user.email
        url = password_reset_path(user.live_password_token)
        expect(ActionMailer::Base.deliveries.last.body).to include(url)
      end
    end

    context "with a not exists email address" do
      let(:user) { Fabricate(:user) }
      let(:incorrect_email) { "#{user.email}test" }

      it "redirects to the forgot password page" do
        post :create, email: incorrect_email
        expect(response).to redirect_to forgot_password_path
      end

      it "does not create a reset password token" do
        post :create, email: incorrect_email
        expect(ResetPasswordToken.count).to eq(0)
      end

      it "does not send out email" do
        post :create, email: incorrect_email
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash[:alert] message" do
        post :create, email: incorrect_email
        expect(flash[:alert]).not_to be_blank
      end
    end
  end
end