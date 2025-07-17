require 'rails_helper'

RSpec.describe 'UserSettings', type: :request do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe 'GET /user_settings' do
    it 'returns http success' do
      get user_settings_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns current user' do
      get user_settings_path
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PATCH /user_settings' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            first_name: 'Updated',
            last_name: 'Name',
            email: 'updated@example.com'
          }
        }
      end

      it 'updates user settings successfully' do
        patch user_settings_path, params: valid_params
        
        expect(response).to redirect_to(user_settings_path)
        expect(flash[:notice]).to eq('Settings updated successfully.')
        
        user.reload
        expect(user.first_name).to eq('Updated')
        expect(user.last_name).to eq('Name')
        expect(user.email).to eq('updated@example.com')
      end

      it 'updates password when provided' do
        password_params = {
          user: {
            password: 'newpassword123',
            password_confirmation: 'newpassword123'
          }
        }

        patch user_settings_path, params: password_params
        
        expect(response).to redirect_to(user_settings_path)
        expect(flash[:notice]).to eq('Settings updated successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            first_name: '',
            email: 'invalid-email'
          }
        }
      end

      it 'renders show template with error' do
        patch user_settings_path, params: invalid_params
        
        expect(response).to have_http_status(:success) # renders show template
        expect(flash[:alert]).to eq('Failed to update settings.')
      end

      it 'does not update user with invalid email' do
        original_email = user.email
        
        patch user_settings_path, params: { user: { email: 'invalid-email' } }
        
        user.reload
        expect(user.email).to eq(original_email)
      end

      it 'does not update user with empty first name' do
        original_first_name = user.first_name
        
        patch user_settings_path, params: { user: { first_name: '' } }
        
        user.reload
        expect(user.first_name).to eq(original_first_name)
      end
    end

    context 'with password mismatch' do
      it 'fails to update with mismatched password confirmation' do
        password_params = {
          user: {
            password: 'newpassword123',
            password_confirmation: 'differentpassword'
          }
        }

        patch user_settings_path, params: password_params
        
        expect(response).to have_http_status(:success) # renders show template
        expect(flash[:alert]).to eq('Failed to update settings.')
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'redirects to login for unauthenticated requests' do
      get user_settings_path
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to login for unauthenticated updates' do
      patch user_settings_path, params: { user: { first_name: 'Test' } }
      expect(response).to redirect_to(login_path)
    end
  end
end 