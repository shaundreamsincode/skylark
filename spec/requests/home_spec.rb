require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    context 'when user is not logged in' do
      it 'returns http success' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the home page' do
        get root_path
        expect(response).to render_template(:index)
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        login_as(user)
      end

      it 'redirects to dashboard' do
        get root_path
        expect(response).to redirect_to(dashboard_path)
      end

      it 'returns http redirect status' do
        get root_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'authentication' do
    it 'allows unauthenticated access' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end 