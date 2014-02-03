class FollowshipsController < ApplicationController

  def index
    @followships = current_user.followships
  end

  def destroy
    followship = Followship.find(params[:id])
    followship.destroy if followship.follower == current_user
    redirect_to people_path
  end

end