class UsersController < ApplicationController

  skip_before_action :require_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to sign_in_path, notice: 'User was created.'
    else
      render :new
    end
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end

end