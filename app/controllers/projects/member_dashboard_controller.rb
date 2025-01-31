class Projects::MemberDashboardController < Projects::ApplicationController
  before_action :authorize_member

  def index
  end

  private

  def authorize_member
    redirect_to project_path(@project), alert: "Not authorized" unless current_user.is_member?(@project)
  end
end
