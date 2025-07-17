require 'rails_helper'

RSpec.describe 'SuperAdmin::Dashboard', type: :request do
  let(:super_admin) { create(:user, super_admin: true) }
  let(:user) { create(:user) }
  let!(:organization) { create(:organization) }
  let!(:project) { create(:project, user: super_admin) }

  describe 'GET /super_admin/dashboard' do
    context 'as super admin' do
      before { login_as(super_admin) }

      it 'returns http success' do
        get super_admin_dashboard_path
        expect(response).to have_http_status(:success)
      end

      it 'assigns all organizations, users, and projects' do
        get super_admin_dashboard_path
        expect(assigns(:organizations)).to include(organization)
        expect(assigns(:users)).to include(super_admin)
        expect(assigns(:projects)).to include(project)
      end
    end

    context 'as non-super admin' do
      before { login_as(user) }

      it 'redirects to root with alert' do
        get super_admin_dashboard_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access denied.')
      end
    end

    context 'when not authenticated' do
      it 'redirects to login' do
        get super_admin_dashboard_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end 