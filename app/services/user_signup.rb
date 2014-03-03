class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripeToken, invitation_token = nil)
    if @user.valid?
      charge = handle_charge_credit_card(stripeToken)
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.welcome_email(@user)
        @status = :success
      else
        @error_message = charge.failure_message
        @status = :failed
      end
    else
      @error_message = "Please fix the error below."
      @status = :failed
    end

    self
  end

  def successful?
    @status == :success
  end

private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      invitation.invitor.bifollow!(@user)
      invitation.update_attributes(token: nil)
    end
  end

  def handle_charge_credit_card(stripeToken)
    StripeWrapper::Charge.create(
      amount: 999,
      card: stripeToken,
      description: "One year charge for #{@user.email}"
    )
  end
end