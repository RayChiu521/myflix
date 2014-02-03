class FollowshipsController < ApplicationController

  def index
    @followships = current_user.followships
  end

  def destroy
    followship = current_user.followships.where(["id = ?", params[:id]]).first
    followship.destroy if followship
    redirect_to people_path
  end

end