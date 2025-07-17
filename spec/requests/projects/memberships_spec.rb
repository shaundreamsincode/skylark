require 'rails_helper'

RSpec.describe 'Projects::Memberships', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:membership) { create(:project_membership, project: project, user: user) }

  before do
    login_as(user)
  end

  describe 'GET /projects/:project_id/memberships/new' do
    it 'returns http success' do
      get new_project_membership_path(project)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /projects/:project_id/memberships' do
    let(:valid_params) do
      {
        request_message: 'I would like to join this project'
      }
    end

    context 'with valid parameters' do
      it 'creates a new membership' do
        expect {
          post project_memberships_path(project), params: valid_params
        }.to change(ProjectMembership, :count).by(1)
      end

      it 'sets the user and project' do
        post project_memberships_path(project), params: valid_params
        
        membership = ProjectMembership.last
        expect(membership.user).to eq(user)
        expect(membership.project).to eq(project)
      end

      it 'sets the request message' do
        post project_memberships_path(project), params: valid_params
        
        membership = ProjectMembership.last
        expect(membership.request_message).to eq('I would like to join this project')
      end

      it 'redirects to project with notice' do
        post project_memberships_path(project), params: valid_params
        expect(response).to redirect_to(project_path(project))
        expect(flash[:notice]).to eq('Membership request submitted successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          request_message: nil
        }
      end

      it 'raises ActiveRecord::NotNullViolation for nil message' do
        expect {
          post project_memberships_path(project), params: invalid_params
        }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end

  describe 'PATCH /projects/:project_id/memberships/:id' do
    let(:other_user) { create(:user) }
    let(:other_membership) { create(:project_membership, project: project, user: other_user) }

    context 'with valid status' do
      it 'updates the membership status' do
        patch project_membership_path(project, other_membership), params: { status: 'approved' }
        
        other_membership.reload
        expect(other_membership.status).to eq('approved')
      end

      it 'redirects to project with notice' do
        patch project_membership_path(project, other_membership), params: { status: 'approved' }
        expect(response).to redirect_to(project_path(project))
        expect(flash[:notice]).to eq('Membership status updated successfully.')
      end

      it 'can reject membership' do
        patch project_membership_path(project, other_membership), params: { status: 'rejected' }
        
        other_membership.reload
        expect(other_membership.status).to eq('rejected')
      end
    end

    context 'with invalid status' do
      it 'raises ArgumentError for invalid status' do
        expect {
          patch project_membership_path(project, other_membership), params: { status: 'invalid_status' }
        }.to raise_error(ArgumentError, "'invalid_status' is not a valid status")
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

      it 'redirects unauthorized users from update' do
        patch project_membership_path(project, membership), params: { status: 'approved' }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication for new' do
      get new_project_membership_path(project)
      expect(response).to redirect_to(login_path)
    end

    it 'requires authentication for create' do
      post project_memberships_path(project), params: { request_message: 'Test' }
      expect(response).to redirect_to(login_path)
    end

    it 'requires authentication for update' do
      patch project_membership_path(project, membership), params: { status: 'approved' }
      expect(response).to redirect_to(login_path)
    end
  end
end 