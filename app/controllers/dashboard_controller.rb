class DashboardController < ApplicationController
  before_action :require_login

  def index
    if current_user.roles.exists?(name: :sponsor)
      @projects = current_user.research_projects
      @notifications = current_user.research_project_notifications.unread
      render "dashboard/index", locals: { dashboard_partial: "dashboard/sponsors" }
    elsif current_user.roles.exists?(name: :collaborator)
      @participation_requests = current_user.participation_requests
      @notifications = current_user.research_project_notifications.unread
      render "dashboard/index", locals: { dashboard_partial: "dashboard/collaborators" }
    else
      redirect_to root_path, alert: "You do not have access to a dashboard."
    end
  end
end
