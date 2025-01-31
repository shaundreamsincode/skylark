class SuperAdmin::DashboardController < SuperAdmin::SuperAdminController
  def index
    @organizations = Organization.all
    @users = User.all
    @projects = Project.all
  end
end
