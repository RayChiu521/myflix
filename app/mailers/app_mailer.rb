class AppMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: "Welcome to MyFlix"
  end

  def password_reset_mail(user)
    @user = user
    mail to: @user.email, subject: "Password reset"
  end

end