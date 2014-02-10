class UsersController < ApplicationController

  skip_before_action :require_user, only: [:new, :create, :reset_password, :save_password, :new_with_invitation_token]
  before_action :set_user, only: [:show]

  def new
    @user = User.new
    @user.email = params[:email] unless params[:email].blank?
    @invitor = params[:invitor]
  end

  def create
    @user = User.new(user_params)

    if @user.save
      bifollow(@user)
      AppMailer.welcome_email(@user).deliver
      redirect_to sign_in_path, notice: 'User was created.'
    else
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

  def bifollow(user)
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      invitation.invitor.bifollow!(user)
      invitation.update_attributes(token: nil)
    end
  end

end