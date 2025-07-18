require 'rails_helper'

RSpec.describe InformationRequest, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      project = create(:project)
      request = create(:information_request, project: project)
      expect(request.project).to eq(project)
    end

    it 'belongs to a user' do
      user = create(:user)
      request = create(:information_request, user: user)
      expect(request.user).to eq(user)
    end

    it 'has many responses' do
      request = create(:information_request)
      response1 = create(:information_request_response, information_request: request)
      response2 = create(:information_request_response, information_request: request)
      expect(request.responses).to include(response1, response2)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      request = build(:information_request)
      expect(request).to be_valid
    end

    it 'requires a title' do
      request = build(:information_request, title: nil)
      expect(request).not_to be_valid
      expect(request.errors[:title]).to include("can't be blank")
    end

    it 'requires a description' do
      request = build(:information_request, description: nil)
      expect(request).not_to be_valid
      expect(request.errors[:description]).to include("can't be blank")
    end
  end

  describe 'token generation' do
    it 'generates a unique token on creation' do
      request = create(:information_request)
      expect(request.token).to be_present
      expect(request.token.length).to eq(20) # SecureRandom.hex(10) = 20 chars
    end

    it 'does not regenerate token if already present' do
      request = build(:information_request, token: 'existing_token')
      request.save!
      expect(request.token).to eq('existing_token')
    end
  end

  describe 'notification creation' do
    let(:project_owner) { create(:user) }
    let(:project) { create(:project, user: project_owner) }
    let(:request_creator) { create(:user) }

    context 'when request is created by someone other than project owner' do
      it 'creates a notification for the project owner' do
        expect {
          create(:information_request, project: project, user: request_creator)
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        request = create(:information_request, project: project, user: request_creator, title: "Test Request")
        
        notification = Notification.last
        expect(notification.user).to eq(project_owner)
        expect(notification.notifiable).to eq(request)
        expect(notification.message).to eq("New information request 'Test Request' created for project '#{project.title}'")
        expect(notification.read).to be false
      end
    end

    context 'when request is created by the project owner' do
      it 'does not create a notification' do
        expect {
          create(:information_request, project: project, user: project_owner)
        }.not_to change(Notification, :count)
      end
    end

    context 'when notification creation fails' do
      before do
        allow(Notification).to receive(:create).and_raise(StandardError.new("Database error"))
        allow(Rails.logger).to receive(:error)
      end

      it 'does not prevent request creation' do
        expect {
          create(:information_request, project: project, user: request_creator)
        }.to change(InformationRequest, :count).by(1)
      end

      it 'logs the error' do
        create(:information_request, project: project, user: request_creator)
        expect(Rails.logger).to have_received(:error).with(/Failed to create information request notification/)
      end
    end

    context 'with special characters in request title' do
      it 'creates notification with properly formatted title' do
        request = create(:information_request, 
                        project: project, 
                        user: request_creator, 
                        title: "Request with 'quotes' & special chars!")
        
        notification = Notification.last
        expected_message = "New information request 'Request with 'quotes' & special chars!' created for project '#{project.title}'"
        expect(notification.message).to eq(expected_message)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid information_request' do
      request = create(:information_request)
      expect(request).to be_persisted
      expect(request.title).to be_present
      expect(request.description).to be_present
      expect(request.project).to be_present
      expect(request.user).to be_present
      expect(request.token).to be_present
    end
  end
end 