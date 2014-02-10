class AppMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: "Welcome to MyFLiX"
  end

  def send_forgot_password(user)
    @user = user
    mail to: @user.email, subject: "Password reset"
  end

  def invite_friend(invitor, friend)
    @invitor = invitor
    @friend = friend
    mail to: @friend[:email], subject: "MyFLiX Invitation"
  end

end