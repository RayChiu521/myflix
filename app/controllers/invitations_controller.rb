class InvitationsController < AuthenticatedController
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      AppMailer.send_invitation(@invitation).deliver
      redirect_to invitation_path, notice:  "Your invitation has sent!"
    else
      render :new
    end
  end

private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge!(invitor: current_user)
  end
end