class FollowsController < ApplicationController

  def index
    @follows = current_user.follows
  end

  def destroy
    follow = current_user.follows.where(["id = ?", params[:id]]).first
    follow.destroy if follow
    redirect_to people_path
  end

end