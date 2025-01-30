
class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    # TODO - also add in projects the user is a collaborator on...
    @projects = Project.where(user: current_user)
  end

  def show
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to projects_path, notice: "Project created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Project created successfully."
    else
      render :edit # TODO - add in flash warnings/notices/etc
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project deleted successfully."
    else
      render :edit # TODO - add in flash warnings/notices/etc
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :summary, :description)
  end
end
