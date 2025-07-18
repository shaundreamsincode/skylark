require 'rails_helper'

RSpec.describe ProjectMembership, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      project = create(:project)
      membership = create(:project_membership, project: project)
      expect(membership.project).to eq(project)
    end

    it 'belongs to a user' do
      user = create(:user)
      membership = create(:project_membership, user: user)
      expect(membership.user).to eq(user)
    end
  end

  describe 'enum status' do
    it 'defaults to pending' do
      membership = create(:project_membership)
      expect(membership.status).to eq('pending')
    end

    it 'can be approved' do
      membership = create(:project_membership, status: :approved)
      expect(membership.status).to eq('approved')
    end

    it 'can be rejected' do
      membership = create(:project_membership, status: :rejected)
      expect(membership.status).to eq('rejected')
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      membership = build(:project_membership)
      expect(membership).to be_valid
    end

    it 'requires a project' do
      membership = build(:project_membership, project: nil)
      expect(membership).not_to be_valid
      expect(membership.errors[:project]).to include('must exist')
    end

    it 'requires a user' do
      membership = build(:project_membership, user: nil)
      expect(membership).not_to be_valid
      expect(membership.errors[:user]).to include('must exist')
    end
  end

  describe 'notification creation on status change' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:membership) { create(:project_membership, user: user, project: project, status: :pending) }

    context 'when status changes to approved' do
      it 'creates a notification for the user' do
        expect {
          membership.update!(status: :approved)
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        membership.update!(status: :approved)
        
        notification = Notification.last
        expect(notification.user).to eq(user)
        expect(notification.notifiable).to eq(project)
        expect(notification.message).to eq("Your membership request for project '#{project.title}' was approved")
        expect(notification.read).to be false
      end
    end

    context 'when status changes to rejected' do
      it 'creates a notification for the user' do
        expect {
          membership.update!(status: :rejected)
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        membership.update!(status: :rejected)
        
        notification = Notification.last
        expect(notification.user).to eq(user)
        expect(notification.notifiable).to eq(project)
        expect(notification.message).to eq("Your membership request for project '#{project.title}' was rejected")
        expect(notification.read).to be false
      end
    end

    context 'when status changes to pending' do
      it 'does not create a notification' do
        membership.update!(status: :approved) # First change to approved
        expect {
          membership.update!(status: :pending)
        }.not_to change(Notification, :count)
      end
    end

    context 'when other attributes change but status remains the same' do
      it 'does not create a notification' do
        expect {
          membership.update!(request_message: "Updated message")
        }.not_to change(Notification, :count)
      end
    end

    context 'when notification creation fails' do
      before do
        allow(Notification).to receive(:create).and_raise(StandardError.new("Database error"))
        allow(Rails.logger).to receive(:error)
      end

      it 'does not prevent status update' do
        expect {
          membership.update!(status: :approved)
        }.to change { membership.reload.status }.from('pending').to('approved')
      end

      it 'logs the error' do
        membership.update!(status: :approved)
        expect(Rails.logger).to have_received(:error).with(/Failed to create membership status notification/)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid project_membership' do
      membership = create(:project_membership)
      expect(membership).to be_persisted
      expect(membership.project).to be_present
      expect(membership.user).to be_present
    end
  end
end 