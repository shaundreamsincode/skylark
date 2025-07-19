require 'rails_helper'

RSpec.describe 'PublicRequests', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:information_request) { create(:information_request, project: project, user: user) }

  describe 'GET /request_for_information/:token' do
    context 'with valid token' do
      it 'returns http success' do
        get public_request_form_path(information_request.token)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /request_for_information/:token' do
    let(:valid_content) { 'This is a test response to the information request.' }

    context 'with valid token and content' do
      it 'creates a response, project note, and notification' do
        expect {
          post public_request_submit_path(information_request.token), params: { content: valid_content }
        }.to change(InformationRequestResponse, :count).by(1)
          .and change(ProjectNote, :count).by(1)
          .and change(Notification, :count).by(1)

        expect(response).to redirect_to(confirm_submission_path)
      end

      it 'creates response with correct content' do
        post public_request_submit_path(information_request.token), params: { content: valid_content }
        
        response = InformationRequestResponse.last
        expect(response.content).to eq(valid_content)
        expect(response.information_request).to eq(information_request)
      end

      it 'creates project note with correct attributes' do
        post public_request_submit_path(information_request.token), params: { content: valid_content }
        
        note = ProjectNote.last
        expect(note.project).to eq(project)
        expect(note.user).to eq(user)
        expect(note.title).to eq(information_request.title)
        expect(note.content).to eq(valid_content)
        expect(note.entry_type).to eq('report')
      end

      it 'creates notification for the information request creator' do
        post public_request_submit_path(information_request.token), params: { content: valid_content }
        
        # Get the notification for the information request (not the project note)
        notification = Notification.where(notifiable: information_request).last
        expect(notification.user).to eq(information_request.user)
        expect(notification.notifiable).to eq(information_request)
        expect(notification.message).to eq("Your information request '#{information_request.title}' received a response")
        expect(notification.read).to be false
      end

      it 'creates notification with correct polymorphic association' do
        post public_request_submit_path(information_request.token), params: { content: valid_content }
        
        # Get the notification for the information request (not the project note)
        notification = Notification.where(notifiable: information_request).last
        expect(notification.notifiable_type).to eq('InformationRequest')
        expect(notification.notifiable_id).to eq(information_request.id)
      end

      it 'does not create notification for other project members' do
        other_user = create(:user)
        create(:project_membership, project: project, user: other_user, status: :approved)
        
        expect {
          post public_request_submit_path(information_request.token), params: { content: valid_content }
        }.to change(Notification, :count).by(2)
        
        # Verify the information request creator gets notified about the response
        response_notification = Notification.where(notifiable: information_request).last
        expect(response_notification.user).to eq(information_request.user)
        expect(response_notification.user).not_to eq(other_user)
      end
    end

    context 'with invalid token' do
      it 'returns not found status and does not create notification' do
        expect {
          post public_request_submit_path('invalid_token'), params: { content: valid_content }
        }.not_to change(Notification, :count)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Invalid request')
      end
    end

    context 'with empty content' do
      it 'fails to submit response and does not create notification' do
        expect {
          post public_request_submit_path(information_request.token), params: { content: '' }
        }.not_to change(Notification, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq('Failed to submit response.')
      end
    end

    context 'when information request has different creator than project owner' do
      let(:request_creator) { create(:user) }
      let(:information_request) { create(:information_request, project: project, user: request_creator) }

      it 'creates notification for the request creator, not project owner' do
        post public_request_submit_path(information_request.token), params: { content: valid_content }
        
        # Get the notification for the information request (not the project note)
        response_notification = Notification.where(notifiable: information_request).last
        expect(response_notification.user).to eq(request_creator)
        expect(response_notification.user).not_to eq(project.user)
      end
    end

    context 'with information request containing special characters in title' do
      let(:information_request) do
        create(:information_request, 
               project: project, 
               user: user, 
               title: "Request with 'quotes' & special chars!")
      end

      it 'creates notification with properly escaped title' do
        post public_request_submit_path(information_request.token), params: { content: valid_content }
        
        # Get the notification for the information request (not the project note)
        notification = Notification.where(notifiable: information_request).last
        expected_message = "Your information request 'Request with 'quotes' & special chars!' received a response"
        expect(notification.message).to eq(expected_message)
      end
    end

    context 'when multiple responses are submitted' do
      it 'updates the existing response and does not create additional notifications' do
        expect {
          post public_request_submit_path(information_request.token), params: { content: 'First response' }
        }.to change(Notification, :count).by(1)

        expect {
          post public_request_submit_path(information_request.token), params: { content: 'Second response' }
        }.not_to change(Notification, :count)

        # Verify the response was updated
        expect(information_request.reload.response.content).to eq('Second response')
        
        # Verify only one notification exists
        notifications = Notification.where(notifiable: information_request)
        expect(notifications.count).to eq(1)
        expect(notifications.first.user).to eq(information_request.user)
      end
    end
  end
end 