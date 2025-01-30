class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  def logged_in?
    session[:user_id].present?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end
end
