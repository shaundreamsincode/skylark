# before_action :authorize_admin
#
# protected
#
# def authorize_admin
#   redirect_to project_path(@project), alert: "Not authorized" unless @project.user == current_user
# end

class Projects::Member::ApplicationController < Projects::ApplicationController
  before_action :authorize_member

  def authorize_admin
    redirect_to project_path(@project), alert: "Not authorized" unless current_user.is_member?(@project)
  end
end
