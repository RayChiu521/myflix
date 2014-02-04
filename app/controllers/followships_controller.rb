class FollowshipsController < ApplicationController

  def index
    @followships = current_user.followships
  end

  def create
    leader = User.find(params[:leader_id])
    Followship.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def destroy
    followship = Followship.find(params[:id])
    followship.destroy if followship.follower == current_user
    redirect_to people_path
  end
end