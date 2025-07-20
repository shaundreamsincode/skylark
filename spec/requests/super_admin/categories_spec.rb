require 'rails_helper'

RSpec.describe 'SuperAdmin::Categories', type: :request do
  let(:super_admin) { create(:user, super_admin: true) }
  let(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:tag) { create(:tag) }

  before { login_as(super_admin) }

  describe 'GET /super_admin/categories' do
    it 'returns http success' do
      get super_admin_categories_path
      expect(response).to have_http_status(:success)
    end
    it 'assigns all categories' do
      get super_admin_categories_path
      expect(assigns(:categories)).to include(category)
    end
  end

  describe 'GET /super_admin/categories/:id' do
    it 'returns http success' do
      get super_admin_category_path(category)
      expect(response).to have_http_status(:success)
    end
    it 'assigns the category' do
      get super_admin_category_path(category)
      expect(assigns(:category)).to eq(category)
    end
  end

  describe 'GET /super_admin/categories/new' do
    it 'returns http success' do
      get new_super_admin_category_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /super_admin/categories' do
    let(:valid_params) { { category: { name: 'New Category', description: 'Desc', tag_ids: [tag.id] } } }
    let(:invalid_params) { { category: { name: '', description: '', tag_ids: [] } } }

    it 'creates a new category with valid params' do
      expect {
        post super_admin_categories_path, params: valid_params
      }.to change(Category, :count).by(1)
    end
    it 'redirects to index with notice' do
      post super_admin_categories_path, params: valid_params
      expect(response).to redirect_to(super_admin_categories_path)
      expect(flash[:notice]).to eq('Category created successfully.')
    end
    it 'renders new with invalid params' do
      post super_admin_categories_path, params: invalid_params
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /super_admin/categories/:id/edit' do
    it 'returns http success' do
      get edit_super_admin_category_path(category)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /super_admin/categories/:id' do
    let(:update_params) { { category: { name: 'Updated Category', description: 'Updated', tag_ids: [tag.id] } } }
    let(:invalid_update_params) { { category: { name: '', description: '', tag_ids: [] } } }

    it 'updates the category with valid params' do
      patch super_admin_category_path(category), params: update_params
      category.reload
      expect(category.name).to eq('Updated Category')
      expect(category.description).to eq('Updated')
    end
    it 'redirects to index with notice' do
      patch super_admin_category_path(category), params: update_params
      expect(response).to redirect_to(super_admin_categories_path)
      expect(flash[:notice]).to eq('Category updated successfully.')
    end
    it 'renders edit with invalid params' do
      patch super_admin_category_path(category), params: invalid_update_params
      expect(response).to render_template(:edit)
    end
  end

  describe 'authorization' do
    before { login_as(user) }
    it 'redirects non-super admins to root' do
      get super_admin_categories_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied.')
    end
  end

  describe 'authentication' do
    before { logout }
    it 'redirects unauthenticated users to login' do
      get super_admin_categories_path
      expect(response).to redirect_to(login_path)
    end
  end
end 