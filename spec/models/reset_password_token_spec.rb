require "spec_helper"

describe ResetPasswordToken do

  it { should belong_to(:user) }

  describe ".token_alive?" do
    let(:user) { Fabricate(:user) }

    it "returns ture if this token belongs to a user and equals to this user's live_password_token" do
      user.generate_password_reset_token
      expect(ResetPasswordToken.token_alive?(user.live_password_token)).to be_true
    end

    it "returns false if this token not belong to any user" do
      user.generate_password_reset_token
      expect(ResetPasswordToken.token_alive?("test#{user.live_password_token}")).to be_false
    end

    it "returns false if this token belongs to a user but token has expired" do
      reset_password_token = Fabricate(:reset_password_token, user: user, expiry_time: Time.now - 1.minute, is_used: false)
      expect(ResetPasswordToken.token_alive?(reset_password_token.token)).to be_false
    end

    it "returns false if this token belongs to a user but token has been used" do
      reset_password_token = Fabricate(:reset_password_token, user: user, expiry_time: Time.now + 1.hour, is_used: true)
      expect(ResetPasswordToken.token_alive?(reset_password_token.token)).to be_false
    end
  end

  describe ".update_password!" do
    let(:user) { Fabricate(:user) }

    context "with alive token" do
      let(:token) do
        user.generate_password_reset_token
        user.live_password_token
      end

      it "updates a user's password if new password is valid" do
        old_password_digest = user.password_digest
        ResetPasswordToken.update_password!(token, "new_password")
        expect(user.reload.password_digest).not_to eq(old_password_digest)
      end

      it "updates user's all password reset records to be used" do
        ResetPasswordToken.update_password!(token, "new_password")
        expect(user.reset_password_tokens.where("is_used = ?", false).count).to be_zero
      end

      it "returns true if new password is valid" do
        expect(ResetPasswordToken.update_password!(token, "password")).to be_true
      end

      it "does not update any user's password if new password is blank" do
        old_password_digest = user.password_digest
        ResetPasswordToken.update_password!(token, "")
        expect(user.reload.password_digest).to eq(old_password_digest)
      end

      it "returns false if new password is blank" do
        expect(ResetPasswordToken.update_password!(token, "")).to be_false
      end
    end

    context "with invalid token" do
      let(:token) do
        user.generate_password_reset_token
        token = user.live_password_token
        user.generate_password_reset_token
        token
      end

      it "does not updates any user's password" do
        old_password_digest = user.password_digest
        ResetPasswordToken.update_password!(token, "new password")
        expect(user.reload.password_digest).to eq(old_password_digest)
      end

      it "returns false if token not exists" do
        expect(ResetPasswordToken.update_password!("test#{token}", "new password")).to be_false
      end
    end
  end

end