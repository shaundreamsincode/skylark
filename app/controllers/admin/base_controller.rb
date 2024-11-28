class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :require_user_has_admin_privileges

  protected

  def require_user_has_admin_privileges
    unless User::ADMIN_EMAILS.include?(current_user.email)
      redirect_to "/dashboard"
    end
  end
end
