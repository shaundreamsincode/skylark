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
      it 'creates a response and project note' do
        expect {
          post public_request_submit_path(information_request.token), params: { content: valid_content }
        }.to change(InformationRequestResponse, :count).by(1)
          .and change(ProjectNote, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Your response has been submitted.')
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
    end

    context 'with invalid token' do
      it 'returns not found status' do
        post public_request_submit_path('invalid_token'), params: { content: valid_content }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Invalid request')
      end
    end

    context 'with empty content' do
      it 'fails to submit response' do
        post public_request_submit_path(information_request.token), params: { content: '' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq('Failed to submit response.')
      end
    end
  end

  describe 'GET /request_for_information/success' do
    it 'returns http success' do
      get public_request_success_path
      expect(response).to have_http_status(:success)
    end
  end
end 