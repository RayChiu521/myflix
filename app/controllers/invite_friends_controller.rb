class InviteFriendsController < ApplicationController

  def new; end

  def create
    if params[:email].blank?
      flash[:alert] = "Please input your Friend's email!"
    elsif User.registered?(params[:email])
      flash[:alert] = "Your friend already is our member!"
    else
      AppMailer.invite_friend(current_user, friend_data).deliver
      flash[:notice] = "Your invitation has sent!"
    end
    redirect_to invite_friend_path
  end

private

  def friend_data
    { name: params[:name], email: params[:email], message: params[:message]}
  end
end