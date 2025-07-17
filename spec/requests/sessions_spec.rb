require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET /login' do
    it 'returns http success' do
      get login_path
      expect(response).to have_http_status(:success)
    end

    it 'redirects to dashboard if user is already logged in' do
      login_as(user)
      get login_path
      
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe 'POST /sessions' do
    context 'with valid credentials' do
      it 'logs in the user and redirects to dashboard' do
        post sessions_path, params: { email: user.email, password: 'password123' }
        
        expect(response).to redirect_to(dashboard_path)
        expect(session[:user_id]).to eq(user.id)
      end

      it 'handles email case insensitively' do
        post sessions_path, params: { email: user.email.upcase, password: 'password123' }
        
        expect(response).to redirect_to(dashboard_path)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'renders login form with error message' do
        post sessions_path, params: { email: user.email, password: 'wrongpassword' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq('Invalid email or password. Please try again.')
      end

      it 'handles non-existent user' do
        post sessions_path, params: { email: 'nonexistent@example.com', password: 'password123' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq('Invalid email or password. Please try again.')
      end

      it 'handles empty email' do
        post sessions_path, params: { email: '', password: 'password123' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq('Invalid email or password. Please try again.')
      end

      it 'handles empty password' do
        post sessions_path, params: { email: user.email, password: '' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq('Invalid email or password. Please try again.')
      end
    end
  end

  describe 'DELETE /logout' do
    before do
      login_as(user)
    end

    it 'logs out the user and redirects to root' do
      delete logout_path
      
      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to be_nil
      expect(flash[:notice]).to eq('You have successfully signed out.')
    end
  end
end 