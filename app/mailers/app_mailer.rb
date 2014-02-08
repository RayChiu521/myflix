class AppMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: "Welcome to MyFlix"
  end

  def send_forgot_password(user)
    @user = user
    mail to: @user.email, subject: "Password reset"
  end

end