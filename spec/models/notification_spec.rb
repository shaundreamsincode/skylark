require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      user = create(:user)
      notification = create(:notification, user: user)
      expect(notification.user).to eq(user)
    end

    it 'belongs to a polymorphic notifiable' do
      project = create(:project)
      notification = create(:notification, notifiable: project)
      expect(notification.notifiable).to eq(project)
    end

    it 'can have different types of notifiables' do
      project = create(:project)
      user = create(:user)
      
      project_notification = create(:notification, notifiable: project)
      user_notification = create(:notification, notifiable: user)
      
      expect(project_notification.notifiable).to eq(project)
      expect(user_notification.notifiable).to eq(user)
    end
  end

  describe 'attributes' do
    it 'has a message' do
      notification = create(:notification, message: 'Test message')
      expect(notification.message).to eq('Test message')
    end

    it 'has a read status that defaults to false' do
      notification = create(:notification)
      expect(notification.read).to be false
    end

    it 'can be marked as read' do
      notification = create(:notification, read: true)
      expect(notification.read).to be true
    end
  end

  describe 'factory' do
    it 'creates a valid notification' do
      notification = create(:notification)
      expect(notification).to be_persisted
      expect(notification.user).to be_present
      expect(notification.notifiable).to be_present
      expect(notification.message).to be_present
    end
  end
end 