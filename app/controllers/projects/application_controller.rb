class Projects::ApplicationController < ApplicationController
  before_action :set_project

  protected

  def set_project
    @project = Project.find(params[:project_id])
  end
end
