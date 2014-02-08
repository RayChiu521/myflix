class PasswordReset < ActiveRecord::Base

  belongs_to :user

  def self.token_alive?(token)
    password_reset = PasswordReset.find_by_token(token)
    if password_reset
      password_reset.user.live_password_token == token
    else
      false
    end
  end

  def self.update_password!(token, new_password)
    return false if new_password.blank?

    password_reset = PasswordReset.where("token = ?", token).try(:first)
    if password_reset && password_reset.user.live_password_token == token
      password_reset.user.update_attributes(password: new_password)
      token_used(password_reset.user)
    else
      false
    end
  end

private

  def self.token_used(user)
    user.password_resets.where(is_used: false).each do |password_reset|
      password_reset.update_attributes(is_used: true)
    end
  end
end