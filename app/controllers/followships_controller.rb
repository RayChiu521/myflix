class FollowshipsController < ApplicationController

  def index
    @followships = current_user.followships
  end

  def create
    leader = User.find(params[:user_id])
    Followship.create(leader: leader, follower: current_user) unless current_user.followed?(leader) || follow_self?(leader)
    redirect_to people_path
  end

  def destroy
    followship = Followship.find(params[:id])
    followship.destroy if followship.follower == current_user
    redirect_to people_path
  end

private

  def follow_self?(leader)
    leader == current_user
  end
end