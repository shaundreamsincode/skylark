require 'rails_helper'

RSpec.describe 'SuperAdmin::Users', type: :request do
  let(:super_admin) { create(:user, super_admin: true) }
  let(:user) { create(:user) }
  let!(:existing_user) { create(:user) }

  before { login_as(super_admin) }

  describe 'GET /super_admin/users' do
    it 'returns http success' do
      get super_admin_users_path
      expect(response).to have_http_status(:success)
    end
    it 'assigns all users' do
      get super_admin_users_path
      expect(assigns(:users)).to include(super_admin, existing_user)
    end
  end

  describe 'GET /super_admin/users/:id' do
    it 'returns http success' do
      get super_admin_user_path(existing_user)
      expect(response).to have_http_status(:success)
    end
    it 'assigns the user' do
      get super_admin_user_path(existing_user)
      expect(assigns(:user)).to eq(existing_user)
    end
  end

  describe 'GET /super_admin/users/new' do
    it 'returns http success' do
      get new_super_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /super_admin/users' do
    let(:valid_params) do
      { user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'john@example.com',
          password: 'password123',
          super_admin: false
        }
      }
    end
    let(:invalid_params) do
      { user: {
          first_name: '',
          last_name: '',
          email: '',
          password: '',
          super_admin: false
        }
      }
    end

    it 'creates a new user with valid params' do
      expect {
        post super_admin_users_path, params: valid_params
      }.to change(User, :count).by(1)
    end
    it 'redirects to index with notice' do
      post super_admin_users_path, params: valid_params
      expect(response).to redirect_to(super_admin_users_path)
      expect(flash[:notice]).to eq('User created successfully.')
    end
    it 'renders new with invalid params' do
      post super_admin_users_path, params: invalid_params
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /super_admin/users/:id/edit' do
    it 'returns http success' do
      get edit_super_admin_user_path(existing_user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /super_admin/users/:id' do
    let(:update_params) do
      { user: {
          first_name: 'Updated',
          last_name: 'Name',
          email: 'updated@example.com',
          super_admin: true
        }
      }
    end
    let(:invalid_update_params) do
      { user: {
          first_name: '',
          last_name: '',
          email: '',
          super_admin: false
        }
      }
    end

    it 'updates the user with valid params' do
      patch super_admin_user_path(existing_user), params: update_params
      existing_user.reload
      expect(existing_user.first_name).to eq('Updated')
      expect(existing_user.super_admin?).to be true
    end
    it 'redirects to index with notice' do
      patch super_admin_user_path(existing_user), params: update_params
      expect(response).to redirect_to(super_admin_users_path)
      expect(flash[:notice]).to eq('User updated successfully.')
    end
    it 'renders edit with invalid params' do
      patch super_admin_user_path(existing_user), params: invalid_update_params
      expect(response).to render_template(:edit)
    end
  end

  describe 'authorization' do
    before { login_as(user) }
    it 'redirects non-super admins to root' do
      get super_admin_users_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied.')
    end
  end

  describe 'authentication' do
    before { logout }
    it 'redirects unauthenticated users to login' do
      get super_admin_users_path
      expect(response).to redirect_to(login_path)
    end
  end
end 