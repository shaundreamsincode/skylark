require 'rails_helper'

RSpec.describe 'Projects::InformationRequests', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:information_request) { create(:information_request, project: project, user: user) }

  before do
    login_as(user)
  end

  describe 'GET /projects/:project_id/information_requests' do
    it 'returns http success' do
      get project_information_requests_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the project information requests' do
      information_request # Create the information request
      get project_information_requests_path(project)
      expect(assigns(:information_requests)).to include(information_request)
    end

    it 'orders requests by created_at desc' do
      old_request = create(:information_request, project: project, user: user, created_at: 2.days.ago)
      new_request = create(:information_request, project: project, user: user, created_at: 1.day.ago)
      
      get project_information_requests_path(project)
      
      expect(assigns(:information_requests).first).to eq(new_request)
      expect(assigns(:information_requests).second).to eq(old_request)
    end
  end

  describe 'GET /projects/:project_id/information_requests/:id' do
    it 'returns http success' do
      get project_information_request_path(project, information_request)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the information request' do
      get project_information_request_path(project, information_request)
      expect(assigns(:information_request)).to eq(information_request)
    end
  end

  describe 'GET /projects/:project_id/information_requests/new' do
    it 'returns http success' do
      get new_project_information_request_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new information request' do
      get new_project_information_request_path(project)
      expect(assigns(:information_request)).to be_a_new(InformationRequest)
    end
  end

  describe 'POST /projects/:project_id/information_requests' do
    let(:valid_params) do
      {
        information_request: {
          title: 'Test Request',
          description: 'Test Description',
          expires_at: 1.week.from_now
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new information request' do
        expect {
          post project_information_requests_path(project), params: valid_params
        }.to change(InformationRequest, :count).by(1)
      end

      it 'sets the user and project' do
        post project_information_requests_path(project), params: valid_params
        
        information_request = InformationRequest.last
        expect(information_request.user).to eq(user)
        expect(information_request.project).to eq(project)
      end

      it 'generates a token' do
        post project_information_requests_path(project), params: valid_params
        
        information_request = InformationRequest.last
        expect(information_request.token).to be_present
        expect(information_request.token.length).to eq(20) # SecureRandom.hex(10) = 20 chars
      end

      it 'redirects to index with notice' do
        post project_information_requests_path(project), params: valid_params
        expect(response).to redirect_to(project_information_requests_path(project))
        expect(flash[:notice]).to eq('Information request created successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          information_request: {
            title: '',
            description: '',
            expires_at: nil
          }
        }
      end

      it 'does not create an information request' do
        expect {
          post project_information_requests_path(project), params: invalid_params
        }.not_to change(InformationRequest, :count)
      end

      it 'renders new template' do
        post project_information_requests_path(project), params: invalid_params
        expect(response).to render_template(:new)
      end

      it 'sets flash alert' do
        post project_information_requests_path(project), params: invalid_params
        expect(flash[:alert]).to eq('Failed to create information request.')
      end
    end
  end

  describe 'GET /projects/:project_id/information_requests/:id/edit' do
    it 'returns http success' do
      get edit_project_information_request_path(project, information_request)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the information request' do
      get edit_project_information_request_path(project, information_request)
      expect(assigns(:information_request)).to eq(information_request)
    end
  end

  describe 'PATCH /projects/:project_id/information_requests/:id' do
    let(:update_params) do
      {
        information_request: {
          title: 'Updated Title',
          description: 'Updated Description',
          expires_at: 2.weeks.from_now
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the information request' do
        patch project_information_request_path(project, information_request), params: update_params
        
        information_request.reload
        expect(information_request.title).to eq('Updated Title')
        expect(information_request.description).to eq('Updated Description')
      end

      it 'redirects to index with notice' do
        patch project_information_request_path(project, information_request), params: update_params
        expect(response).to redirect_to(project_information_requests_path(project))
        expect(flash[:notice]).to eq('Information request updated successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          information_request: {
            title: '',
            description: '',
            expires_at: nil
          }
        }
      end

      it 'does not update the information request' do
        original_title = information_request.title
        patch project_information_request_path(project, information_request), params: invalid_update_params
        
        information_request.reload
        expect(information_request.title).to eq(original_title)
      end

      it 'renders edit template' do
        patch project_information_request_path(project, information_request), params: invalid_update_params
        expect(response).to render_template(:edit)
      end

      it 'sets flash alert' do
        patch project_information_request_path(project, information_request), params: invalid_update_params
        expect(flash[:alert]).to eq('Failed to update information request.')
      end
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user) }
    let(:other_project) { create(:project, user: other_user) }

    context 'when user is not the project owner or member' do
      before do
        login_as(other_user)
      end

      it 'redirects unauthorized users from index' do
        get project_information_requests_path(project)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from show' do
        get project_information_request_path(project, information_request)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from new' do
        get new_project_information_request_path(project)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from create' do
        post project_information_requests_path(project), params: { information_request: { title: 'Test' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication for index' do
      get project_information_requests_path(project)
      expect(response).to redirect_to(login_path)
    end

    it 'requires authentication for show' do
      get project_information_request_path(project, information_request)
      expect(response).to redirect_to(login_path)
    end
  end
end 