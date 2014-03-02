class UserSignUp

  attr_accessor :error_message

  def initialize(user, stripeToken, invitation_token = nil)
    @user = user
    @stripeToken = stripeToken
    @invitation_token = invitation_token
  end

  def sign_up
    unless @user.valid?
      error_message = "Please fix the error below."
      return false
    end

    charge = handle_charge_credit_card
    unless charge.successful?
      error_message = charge.failure_message
      return false
    end

    @user.save
    handle_invitation
    AppMailer.delay.welcome_email(@user)
    return true
  end

private

  def handle_invitation
    if @invitation_token.present?
      invitation = Invitation.where(token: @invitation_token).first
      invitation.invitor.bifollow!(@user)
      invitation.update_attributes(token: nil)
    end
  end

  def handle_charge_credit_card
    StripeWrapper::Charge.create(
      amount: 999,
      card: @stripeToken,
      description: "One year charge for #{@user.email}"
    )
  end
end