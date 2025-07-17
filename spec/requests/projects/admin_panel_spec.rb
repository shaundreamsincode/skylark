require 'rails_helper'

RSpec.describe 'Projects::AdminPanel', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:pending_membership) { create(:project_membership, project: project, status: 'pending') }
  let!(:approved_membership) { create(:project_membership, project: project, status: 'approved') }

  before do
    login_as(user)
  end

  describe 'GET /projects/:project_id/admin_panel' do
    it 'returns http success' do
      get project_admin_panel_index_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'assigns pending membership requests' do
      get project_admin_panel_index_path(project)
      expect(assigns(:membership_requests)).to include(pending_membership)
      expect(assigns(:membership_requests)).not_to include(approved_membership)
    end

    it 'assigns approved members' do
      get project_admin_panel_index_path(project)
      expect(assigns(:members)).to include(approved_membership)
      expect(assigns(:members)).not_to include(pending_membership)
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user) }
    before { login_as(other_user) }

    it 'redirects unauthorized users' do
      get project_admin_panel_index_path(project)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'authentication' do
    before { logout }

    it 'requires authentication' do
      get project_admin_panel_index_path(project)
      expect(response).to redirect_to(login_path)
    end
  end
end 