
class ResearchProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authorize_sponsor, only: [:edit, :update, :destroy]

  def index
    @projects = ResearchProject.all
  end

  def show
  end

  def new
    @project = current_user.research_projects.new
  end

  def create
    @project = current_user.research_projects.new(project_params)
    if @project.save
      redirect_to research_projects_path, notice: "Project created successfully."
    else
      render :new
    end
  end

  private

  def set_project
    @project = ResearchProject.find(params[:id])
  end

  def project_params
    params.require(:research_project).permit(:title, :summary, :description)
  end

  def authorize_sponsor
    redirect_to research_projects_path, alert: "Not authorized" unless @project.sponsor == current_user
  end
end
