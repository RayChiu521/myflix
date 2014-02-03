class FollowsController < ApplicationController

  def index
    @follows = current_user.follows
  end

  def destroy
  end

end