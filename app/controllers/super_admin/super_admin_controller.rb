class SuperAdmin::SuperAdminController < ApplicationController
  before_action :require_super_admin

  protected

  def require_super_admin
    unless current_user&.super_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
