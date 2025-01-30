class Projects::Admin::ApplicationController < Projects::ApplicationController
  before_action :authorize_admin

  protected

  def authorize_admin
    redirect_to project_path(@project), alert: "Not authorized" unless @project.user == current_user
  end
end
