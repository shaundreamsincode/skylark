class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :require_user_has_admin_privileges

  protected

  def require_user_has_admin_privileges
    unless current_user.is_admin?
      redirect_to "/dashboard"
    end
  end
end
