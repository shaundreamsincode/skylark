require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:project) { create(:project, user: other_user) }

  before do
    login_as(user)
  end

  describe 'GET /notifications' do
    it 'returns http success' do
      get notifications_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns user notifications ordered by created_at desc' do
      # Create notifications with different timestamps
      old_notification = create(:notification, user: user, created_at: 2.days.ago)
      new_notification = create(:notification, user: user, created_at: 1.day.ago)
      
      get notifications_path
      
      expect(assigns(:notifications)).to eq([new_notification, old_notification])
    end

    it 'only shows notifications for current user' do
      user_notification = create(:notification, user: user)
      other_user_notification = create(:notification, user: other_user)
      
      get notifications_path
      
      expect(assigns(:notifications)).to include(user_notification)
      expect(assigns(:notifications)).not_to include(other_user_notification)
    end
  end

  describe 'PATCH /notifications/:id/mark_as_read' do
    let!(:notification) { create(:notification, user: user, read: false) }

    it 'marks notification as read' do
      expect {
        patch mark_as_read_notification_path(notification)
      }.to change { notification.reload.read }.from(false).to(true)
    end

    it 'redirects to dashboard with success message' do
      patch mark_as_read_notification_path(notification)
      
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:notice]).to eq('Notification marked as read.')
    end

    it 'only allows user to mark their own notifications as read' do
      other_notification = create(:notification, user: other_user, read: false)
      
      expect {
        patch mark_as_read_notification_path(other_notification)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'works with already read notifications' do
      read_notification = create(:notification, user: user, read: true)
      
      patch mark_as_read_notification_path(read_notification)
      
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:notice]).to eq('Notification marked as read.')
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'redirects to login for unauthenticated index requests' do
      get notifications_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to login for unauthenticated mark_as_read requests' do
      notification = create(:notification, user: user)
      patch mark_as_read_notification_path(notification)
      expect(response).to redirect_to(login_path)
    end
  end
end 