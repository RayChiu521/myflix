class PagesController < ApplicationController

  skip_before_action :require_user, only: [:front, :invalid_token]

  def front
    redirect_to home_path if logged_in?
  end

  def invalid_token; end

end