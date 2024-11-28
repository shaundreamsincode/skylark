class ApplicationController < ActionController::Base
  layout :determine_layout

  before_action :require_login
  before_action :track_page_view

  helper_method :current_user

  def logged_in?
    session[:user_id]
  end

  def require_login
    if !logged_in?
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def track_page_view
    unless current_user.present? && current_user.is_admin?
      PageView.create(
        user_id: current_user&.id, # This will be nil for non-logged-in users
        page_name: "#{controller_name}##{action_name}",
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
    end
  end

  private

  def determine_layout
    current_user ? "logged_in" : "application"
  end
end
