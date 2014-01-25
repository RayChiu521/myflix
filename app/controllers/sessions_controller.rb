class SessionsController < ApplicationController

  skip_before_action :require_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "You've logged in."
    else
      redirect_to sign_in_path, alert: "There's something wrong with your email or password."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You've logged out."
  end
end