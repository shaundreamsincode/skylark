class Projects::PreviewController < Projects::ApplicationController
  skip_before_action :authorize_user

  def index
  end
end
