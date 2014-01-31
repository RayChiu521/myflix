class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :require_user
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def access_denied(msg = "Access reserved for members only. Please sign in first.")
    flash[:alert] = msg
    redirect_to sign_in_path
  end

  private

    def require_user
      access_denied unless logged_in?
    end

end
