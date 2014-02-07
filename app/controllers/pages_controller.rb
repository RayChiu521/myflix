class PagesController < ApplicationController

  skip_before_action :require_user, only: [:front, :confirm_password_reset]

  def front
    redirect_to home_path if logged_in?
  end

  def confirm_password_reset; end

end