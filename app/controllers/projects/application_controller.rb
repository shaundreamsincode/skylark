class Projects::ApplicationController < ApplicationController
  before_action :set_project
  before_action :authorize_user


  protected

  def set_project
    @project = Project.find(params[:project_id])
  end
end
def authorize_user
  unless current_user == @project.user || current_user.is_member?(@project)
    redirect_to root_path(@project), alert: "Not authorized"
  end
end
