require 'rails_helper'

RSpec.describe InformationRequestResponse, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:information_request) { create(:information_request, project: project, user: user) }

  describe 'associations' do
    it 'belongs to an information request' do
      response = create(:information_request_response, information_request: information_request)
      expect(response.information_request).to eq(information_request)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      response = build(:information_request_response, information_request: information_request)
      expect(response).to be_valid
    end

    it 'requires content' do
      response = build(:information_request_response, information_request: information_request, content: nil)
      expect(response).not_to be_valid
      expect(response.errors[:content]).to include("can't be blank")
    end

    it 'requires an information request' do
      response = build(:information_request_response, information_request: nil)
      expect(response).not_to be_valid
      expect(response.errors[:information_request]).to include('must exist')
    end
  end

  describe 'notification creation callback' do
    context 'when a response is created' do
      it 'creates a notification for the information request creator' do
        expect {
          create(:information_request_response, information_request: information_request)
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        response = create(:information_request_response, information_request: information_request)
        
        notification = Notification.last
        expect(notification.user).to eq(information_request.user)
        expect(notification.notifiable).to eq(information_request)
        expect(notification.message).to eq("Your information request '#{information_request.title}' received a response")
        expect(notification.read).to be false
      end

      it 'creates notification with correct polymorphic association' do
        response = create(:information_request_response, information_request: information_request)
        
        notification = Notification.last
        expect(notification.notifiable_type).to eq('InformationRequest')
        expect(notification.notifiable_id).to eq(information_request.id)
      end
    end

    context 'when information request creator is different from project owner' do
      let(:request_creator) { create(:user) }
      let(:information_request) { create(:information_request, project: project, user: request_creator) }

      it 'creates notification for the request creator' do
        response = create(:information_request_response, information_request: information_request)
        
        notification = Notification.last
        expect(notification.user).to eq(request_creator)
        expect(notification.user).not_to eq(project.user)
      end
    end

    context 'when multiple responses are created for the same request' do
      it 'creates a notification for each response' do
        expect {
          create(:information_request_response, information_request: information_request)
        }.to change(Notification, :count).by(1)

        expect {
          create(:information_request_response, information_request: information_request)
        }.to change(Notification, :count).by(1)

        # Verify both notifications are for the same user and information request
        notifications = Notification.last(2)
        expect(notifications.map(&:user).uniq).to eq([information_request.user])
        expect(notifications.map(&:notifiable).uniq).to eq([information_request])
      end
    end

    context 'when information request has special characters in title' do
      let(:information_request) do
        create(:information_request, 
               project: project, 
               user: user, 
               title: "Request with 'quotes' & special chars!")
      end

      it 'creates notification with properly formatted title' do
        response = create(:information_request_response, information_request: information_request)
        
        notification = Notification.last
        expected_message = "Your information request 'Request with 'quotes' & special chars!' received a response"
        expect(notification.message).to eq(expected_message)
      end
    end

    context 'when response creation fails' do
      it 'does not create notification if response is invalid' do
        expect {
          InformationRequestResponse.create(information_request: information_request, content: nil)
        }.not_to change(Notification, :count)
      end
    end

    context 'when notification creation fails' do
      before do
        allow(Notification).to receive(:create).and_raise(StandardError.new("Database error"))
        allow(Rails.logger).to receive(:error)
      end

      it 'does not prevent response creation' do
        expect {
          create(:information_request_response, information_request: information_request)
        }.to change(InformationRequestResponse, :count).by(1)
      end

      it 'logs the error' do
        create(:information_request_response, information_request: information_request)
        expect(Rails.logger).to have_received(:error).with(/Failed to create notification for information request response/)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid information request response' do
      response = create(:information_request_response, information_request: information_request)
      expect(response).to be_persisted
      expect(response.information_request).to eq(information_request)
      expect(response.content).to be_present
    end
  end
end 