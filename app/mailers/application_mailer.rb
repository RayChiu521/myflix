class ApplicationMailer < ActionMailer::Base

  helper_method :website_host, :email_account

  def email_account
    @email_account ||= ENV["EMAIL_ACCOUNT"]
  end

  def website_host
    @website_host ||= ENV["WEBSITE_HOST"]
  end
end