class AdminsController < AuthenticatedController
  before_action :require_admin

private

  def require_admin
    redirect_to root_path, alert: "You do not have access to that area!" unless current_user.admin?
  end
end