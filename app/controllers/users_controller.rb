class UsersController < ApplicationController

  skip_before_action :require_user, only: [:new, :create, :reset_password, :save_password]
  before_action :set_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      AppMailer.welcome_email(@user).deliver
      redirect_to sign_in_path, notice: 'User was created.'
    else
      render :new
    end
  end

  def show
  end

  def reset_password
    redirect_to invalid_token_path unless ResetPasswordToken.token_alive?(params[:id])
  end

  def save_password
    if ResetPasswordToken.update_password!(params[:token], params[:password])
      redirect_to sign_in_path, notice: "Your password has been changed."
    else
      redirect_to reset_password_path(params[:token]), alert: "Please input your new password."
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def set_user
    @user = User.find(params[:id])
  end

end