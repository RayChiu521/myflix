class PagesController < ApplicationController

  skip_before_action :require_user, only: [:front]

  def front
    redirect_to videos_path if logged_in?
  end

end