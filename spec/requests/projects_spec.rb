require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:organization) { create(:organization) }

  before do
    login_as(user)
  end

  describe 'GET /projects' do
    it 'returns http success' do
      get projects_path
      expect(response).to have_http_status(:success)
    end

    it 'shows only user\'s owned and member projects' do
      owned_project = create(:project, user: user)
      member_project = create(:project, user: other_user)
      create(:project_membership, project: member_project, user: user, status: :approved)
      unrelated_project = create(:project, user: other_user)

      get projects_path
      
      expect(response.body).to include(owned_project.title)
      expect(response.body).to include(member_project.title)
      expect(response.body).not_to include(unrelated_project.title)
    end
  end

  describe 'GET /projects/:id' do
    let(:project) { create(:project, user: user) }

    it 'returns http success for owned project' do
      get project_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'returns http success for member project' do
      member_project = create(:project, user: other_user)
      create(:project_membership, project: member_project, user: user, status: :approved)
      
      get project_path(member_project)
      expect(response).to have_http_status(:success)
    end

    it 'redirects to preview for non-member project' do
      other_project = create(:project, user: other_user)
      
      get project_path(other_project)
      expect(response).to redirect_to(project_preview_index_path(other_project))
    end
  end

  describe 'GET /projects/new' do
    it 'returns http success' do
      get new_project_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /projects' do
    let(:valid_params) do
      {
        project: {
          title: 'Test Project',
          summary: 'A test project',
          description: 'This is a test project description'
        }
      }
    end

    it 'creates a new project with valid params' do
      expect {
        post projects_path, params: valid_params
      }.to change(Project, :count).by(1)

      expect(response).to redirect_to(projects_path)
      expect(flash[:notice]).to eq('Project created successfully.')
    end

    it 'creates project with current user as owner' do
      post projects_path, params: valid_params
      
      project = Project.last
      expect(project.user).to eq(user)
    end

    it 'renders new template with invalid params' do
      invalid_params = { project: { title: '' } }
      
      post projects_path, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /projects/:id/edit' do
    let(:project) { create(:project, user: user) }

    it 'returns http success for owned project' do
      get edit_project_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'returns http success for member project' do
      member_project = create(:project, user: other_user)
      create(:project_membership, project: member_project, user: user, status: :approved)
      
      get edit_project_path(member_project)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /projects/:id' do
    let(:project) { create(:project, user: user) }

    it 'updates project with valid params' do
      update_params = {
        project: {
          title: 'Updated Project Title',
          summary: 'Updated summary'
        }
      }

      patch project_path(project), params: update_params
      
      expect(response).to redirect_to(project_path(project))
      expect(flash[:notice]).to eq('Project updated successfully.')
      expect(project.reload.title).to eq('Updated Project Title')
    end

    it 'renders edit template with invalid params' do
      invalid_params = { project: { title: '' } }
      
      patch project_path(project), params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /projects/:id' do
    let!(:project) { create(:project, user: user) }

    it 'deletes the project' do
      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)

      expect(response).to redirect_to(projects_path)
      expect(flash[:notice]).to eq('Project deleted successfully.')
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'redirects to login for unauthenticated requests' do
      get projects_path
      expect(response).to redirect_to(login_path)
    end
  end
end 