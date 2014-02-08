class PasswordResetsController < ApplicationController
  skip_before_action :require_user, only: [:show, :create, :expired_token]

  def show
    redirect_to expired_token_path unless ResetPasswordToken.token_alive?(params[:id])
  end

  def create
    if ResetPasswordToken.update_password!(params[:token], params[:password])
      redirect_to sign_in_path, notice: "Your password has been changed."
    else
      redirect_to password_reset_path(params[:token]), alert: "Please input your new password."
    end
  end

  def expired_token; end

end