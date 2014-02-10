class UsersController < ApplicationController

  skip_before_action :require_user, only: [:new, :create, :reset_password, :save_password]
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

private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def bifollow(user)
    unless params[:invitor].blank?
      leader = User.find(params[:invitor])
      leader.bifollow!(user)
    end
  end

end