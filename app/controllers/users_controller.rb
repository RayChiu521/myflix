class UsersController < ApplicationController

  skip_before_action :require_user, only: [:new, :create, :forgot_password, :email_password_token]
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

  def forgot_password; end

  def email_password_token
    user = User.find_by_email(params[:email])
    if user
      user.generate_password_reset_token
      AppMailer.password_reset_mail(user).deliver
      redirect_to confirm_password_reset_path
    else
      redirect_to forgot_password_path, alert: "Incorrect email address!"
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