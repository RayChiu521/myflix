class AppMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: "Welcome to MyFLiX"
  end

  def send_forgot_password(user)
    @user = user
    mail to: @user.email, subject: "Password reset"
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: "Invitation to join MyFLiX"
  end

  def charge_failed(user)
    @user = user
    mail to: user.email, subject: "There is something wrong with your credit card"
  end
end