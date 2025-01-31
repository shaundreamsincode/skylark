class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!
    redirect_to dashboard_path, notice: "Notification marked as read."
  end
end
