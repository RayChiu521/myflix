class ForgotPasswordsController < ApplicationController

  skip_before_action :require_user, only: [:new, :create, :confirm]

  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.generate_password_reset_token
      AppMailer.password_reset_mail(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      redirect_to forgot_password_path, alert: "Incorrect email address!"
    end
  end

  def confirm; end

end