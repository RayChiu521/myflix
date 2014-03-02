class UsersController < AuthenticatedController

  skip_before_action :require_user, only: [:new, :create, :new_with_invitation_token]
  before_action :set_user, only: [:show]

  def new
    @user = User.new
    @user.email = params[:email] unless params[:email].blank?
    @invitor = params[:invitor]
  end

  def create
    @user = User.new(user_params)
    userSignUp = UserSignUp.new(@user, params[:stripeToken], params[:invitation_token])

    if userSignUp.sign_up
      redirect_to sign_in_path, notice: 'User was created.'
    else
      flash.now[:alert] = userSignUp.error_message
      render :new
    end
  end

  def show
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def set_user
    @user = User.find(params[:id])
  end
end