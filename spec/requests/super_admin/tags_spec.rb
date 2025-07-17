require 'rails_helper'

RSpec.describe 'SuperAdmin::Tags', type: :request do
  let(:super_admin) { create(:user, super_admin: true) }
  let(:user) { create(:user) }
  let!(:tag) { create(:tag) }

  before { login_as(super_admin) }

  describe 'GET /super_admin/tags' do
    it 'returns http success' do
      get super_admin_tags_path
      expect(response).to have_http_status(:success)
    end
    it 'assigns all tags' do
      get super_admin_tags_path
      expect(assigns(:tags)).to include(tag)
    end
  end

  describe 'GET /super_admin/tags/:id' do
    it 'returns http success' do
      get super_admin_tag_path(tag)
      expect(response).to have_http_status(:success)
    end
    it 'assigns the tag' do
      get super_admin_tag_path(tag)
      expect(assigns(:tag)).to eq(tag)
    end
  end

  describe 'GET /super_admin/tags/new' do
    it 'returns http success' do
      get new_super_admin_tag_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /super_admin/tags' do
    let(:valid_params) { { tag: { name: 'New Tag' } } }
    let(:invalid_params) { { tag: { name: '' } } }

    it 'creates a new tag with valid params' do
      expect {
        post super_admin_tags_path, params: valid_params
      }.to change(Tag, :count).by(1)
    end
    it 'redirects to index with notice' do
      post super_admin_tags_path, params: valid_params
      expect(response).to redirect_to(super_admin_tags_path)
      expect(flash[:notice]).to eq('Tag created successfully.')
    end
    it 'renders new with invalid params' do
      post super_admin_tags_path, params: invalid_params
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /super_admin/tags/:id/edit' do
    it 'returns http success' do
      get edit_super_admin_tag_path(tag)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /super_admin/tags/:id' do
    let(:update_params) { { tag: { name: 'Updated Tag' } } }
    let(:invalid_update_params) { { tag: { name: '' } } }

    it 'updates the tag with valid params' do
      patch super_admin_tag_path(tag), params: update_params
      tag.reload
      expect(tag.name).to eq('Updated Tag')
    end
    it 'redirects to index with notice' do
      patch super_admin_tag_path(tag), params: update_params
      expect(response).to redirect_to(super_admin_tags_path)
      expect(flash[:notice]).to eq('Tag updated successfully.')
    end
    it 'renders edit with invalid params' do
      patch super_admin_tag_path(tag), params: invalid_update_params
      expect(response).to render_template(:edit)
    end
  end

  describe 'DELETE /super_admin/tags/:id' do
    it 'deletes the tag' do
      tag_to_delete = create(:tag)
      expect {
        delete super_admin_tag_path(tag_to_delete)
      }.to change(Tag, :count).by(-1)
    end
    it 'redirects to index with notice' do
      tag_to_delete = create(:tag)
      delete super_admin_tag_path(tag_to_delete)
      expect(response).to redirect_to(super_admin_tags_path)
      expect(flash[:notice]).to eq('Tag deleted successfully.')
    end
  end

  describe 'authorization' do
    before { login_as(user) }
    it 'redirects non-super admins to root' do
      get super_admin_tags_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied.')
    end
  end

  describe 'authentication' do
    before { logout }
    it 'redirects unauthenticated users to login' do
      get super_admin_tags_path
      expect(response).to redirect_to(login_path)
    end
  end
end 