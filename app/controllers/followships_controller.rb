class FollowshipsController < AuthenticatedController

  def index
    @followships = current_user.followships
  end

  def create
    leader = User.find(params[:leader_id])
    current_user.follow!(leader)
    redirect_to people_path
  end

  def destroy
    followship = Followship.find(params[:id])
    followship.destroy if followship.follower == current_user
    redirect_to people_path
  end
end