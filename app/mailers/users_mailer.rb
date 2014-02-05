class UsersMailer < ApplicationMailer
  # default from: email_account

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to MyFlix")
  end

end