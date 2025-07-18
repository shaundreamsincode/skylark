class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @owned_projects = Project.where(user: current_user)
    
    @approved_member_projects = Project.joins(:project_memberships)
      .where(project_memberships: { user: current_user, status: "approved" })
    
    @pending_member_projects = Project.joins(:project_memberships)
      .where(project_memberships: { user: current_user, status: "pending" })
  end

  def show
    @project = Project.find(params[:id])

    unless current_user == @project.user || current_user.is_member?(@project)
      return redirect_to project_preview_index_path(@project)
    end
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to projects_path, notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity # TODO - add in flash warnings/notices/etc
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project deleted successfully."
    else
      render :edit, status: :unprocessable_entity # TODO - add in flash warnings/notices/etc
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :summary, :description, tag_ids: [])
  end
end
