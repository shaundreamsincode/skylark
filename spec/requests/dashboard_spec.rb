require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  let(:user) { create(:user) }

  describe 'GET /dashboard' do
    context 'when authenticated' do
      before do
        login_as(user)
      end

      it 'returns http success' do
        get dashboard_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the dashboard template' do
        get dashboard_path
        expect(response).to render_template(:index)
      end
    end

    context 'when not authenticated' do
      it 'redirects to login' do
        get dashboard_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end 