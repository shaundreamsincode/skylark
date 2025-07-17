require 'rails_helper'

RSpec.describe 'SuperAdmin::Organizations', type: :request do
  let(:super_admin) { create(:user, super_admin: true) }
  let(:user) { create(:user) }
  let!(:organization) { create(:organization) }
  let!(:other_user) { create(:user) }

  before { login_as(super_admin) }

  describe 'GET /super_admin/organizations' do
    it 'returns http success' do
      get super_admin_organizations_path
      expect(response).to have_http_status(:success)
    end
    it 'assigns all organizations' do
      get super_admin_organizations_path
      expect(assigns(:organizations)).to include(organization)
    end
  end

  describe 'GET /super_admin/organizations/:id' do
    it 'returns http success' do
      get super_admin_organization_path(organization)
      expect(response).to have_http_status(:success)
    end
    it 'assigns the organization and memberships' do
      get super_admin_organization_path(organization)
      expect(assigns(:organization)).to eq(organization)
      expect(assigns(:memberships)).to eq(organization.organization_memberships)
    end
  end

  describe 'GET /super_admin/organizations/new' do
    it 'returns http success' do
      get new_super_admin_organization_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /super_admin/organizations' do
    let(:valid_params) { { organization: { name: 'New Org' } } }
    let(:invalid_params) { { organization: { name: '' } } }

    it 'creates a new organization with valid params' do
      expect {
        post super_admin_organizations_path, params: valid_params
      }.to change(Organization, :count).by(1)
    end
    it 'redirects to index with notice' do
      post super_admin_organizations_path, params: valid_params
      expect(response).to redirect_to(super_admin_organizations_path)
      expect(flash[:notice]).to eq('Organization created successfully.')
    end
    it 'renders new with invalid params' do
      post super_admin_organizations_path, params: invalid_params
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /super_admin/organizations/:id/edit' do
    it 'returns http success' do
      get edit_super_admin_organization_path(organization)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /super_admin/organizations/:id' do
    let(:update_params) { { organization: { name: 'Updated Org' } } }
    let(:invalid_update_params) { { organization: { name: '' } } }

    it 'updates the organization with valid params' do
      patch super_admin_organization_path(organization), params: update_params
      organization.reload
      expect(organization.name).to eq('Updated Org')
    end
    it 'redirects to index with notice' do
      patch super_admin_organization_path(organization), params: update_params
      expect(response).to redirect_to(super_admin_organizations_path)
      expect(flash[:notice]).to eq('Organization updated successfully.')
    end
    it 'renders edit with invalid params' do
      patch super_admin_organization_path(organization), params: invalid_update_params
      expect(response).to render_template(:edit)
    end
  end

  describe 'DELETE /super_admin/organizations/:id' do
    it 'deletes the organization' do
      org = create(:organization)
      expect {
        delete super_admin_organization_path(org)
      }.to change(Organization, :count).by(-1)
    end
    it 'redirects to index with notice' do
      org = create(:organization)
      delete super_admin_organization_path(org)
      expect(response).to redirect_to(super_admin_organizations_path)
      expect(flash[:notice]).to eq('Organization deleted successfully.')
    end
  end

  describe 'POST /super_admin/organizations/:id/add_member' do
    it 'adds a user as a member' do
      expect {
        post add_member_super_admin_organization_path(organization), params: { user_id: other_user.id, role: 'member' }
      }.to change(organization.organization_memberships, :count).by(1)
    end
    it 'redirects with notice if added' do
      post add_member_super_admin_organization_path(organization), params: { user_id: other_user.id, role: 'member' }
      expect(response).to redirect_to(super_admin_organization_path(organization))
      expect(flash[:notice]).to eq('User added successfully.')
    end
    it 'redirects with alert if already a member' do
      organization.organization_memberships.create(user: other_user, role: 'member')
      post add_member_super_admin_organization_path(organization), params: { user_id: other_user.id, role: 'member' }
      expect(response).to redirect_to(super_admin_organization_path(organization))
      expect(flash[:alert]).to eq('User is already a member.')
    end
  end

  describe 'DELETE /super_admin/organizations/:id/remove_member' do
    it 'removes a user as a member' do
      membership = organization.organization_memberships.create(user: other_user, role: 'member')
      expect {
        delete remove_member_super_admin_organization_path(organization), params: { user_id: other_user.id }
      }.to change(organization.organization_memberships, :count).by(-1)
    end
    it 'redirects with notice if removed' do
      organization.organization_memberships.create(user: other_user, role: 'member')
      delete remove_member_super_admin_organization_path(organization), params: { user_id: other_user.id }
      expect(response).to redirect_to(super_admin_organization_path(organization))
      expect(flash[:notice]).to eq('User removed successfully.')
    end
    it 'redirects with alert if not a member' do
      delete remove_member_super_admin_organization_path(organization), params: { user_id: other_user.id }
      expect(response).to redirect_to(super_admin_organization_path(organization))
      expect(flash[:alert]).to eq('User is not a member.')
    end
  end

  describe 'PATCH /super_admin/organizations/:id/update_role' do
    it 'updates a user role' do
      membership = organization.organization_memberships.create(user: other_user, role: 'member')
      patch update_role_super_admin_organization_path(organization), params: { user_id: other_user.id, role: 'admin' }
      expect(membership.reload.role).to eq('admin')
    end
    it 'redirects with notice if updated' do
      organization.organization_memberships.create(user: other_user, role: 'member')
      patch update_role_super_admin_organization_path(organization), params: { user_id: other_user.id, role: 'admin' }
      expect(response).to redirect_to(super_admin_organization_path(organization))
      expect(flash[:notice]).to eq('User role updated successfully.')
    end
    it 'redirects with alert if not a member' do
      patch update_role_super_admin_organization_path(organization), params: { user_id: other_user.id, role: 'admin' }
      expect(response).to redirect_to(super_admin_organization_path(organization))
      expect(flash[:alert]).to eq('User is not a member.')
    end
  end

  describe 'authorization' do
    before { login_as(user) }
    it 'redirects non-super admins to root' do
      get super_admin_organizations_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied.')
    end
  end

  describe 'authentication' do
    before { logout }
    it 'redirects unauthenticated users to login' do
      get super_admin_organizations_path
      expect(response).to redirect_to(login_path)
    end
  end
end 