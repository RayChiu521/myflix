require_relative '../../lib/tokenable'

class ResetPasswordToken < ActiveRecord::Base

  include Tokenable

  belongs_to :user

  def self.token_alive?(token)
    reset_password_token = ResetPasswordToken.find_by_token(token)
    if reset_password_token
      reset_password_token.user.live_password_token == token
    else
      false
    end
  end

  def self.update_password!(token, new_password)
    return false if new_password.blank?

    reset_password_token = ResetPasswordToken.where("token = ?", token).try(:first)
    if reset_password_token && reset_password_token.user.live_password_token == token
      reset_password_token.user.update_attributes(password: new_password)
      token_used(reset_password_token.user)
    else
      false
    end
  end

private

  def self.token_used(user)
    user.reset_password_tokens.where(is_used: false).each do |reset_password_token|
      reset_password_token.update_attributes(is_used: true)
    end
  end
end