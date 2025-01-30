class Projects::Admin::DashboardController < Projects::Admin::ApplicationController
  def index
    @membership_requests = @project.project_memberships.pending
    @members = @project.project_memberships.approved
  end
end
