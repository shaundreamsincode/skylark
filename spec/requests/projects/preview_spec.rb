require 'rails_helper'

RSpec.describe 'Projects::Preview', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    login_as(user)
  end

  describe 'GET /projects/:project_id/preview' do
    it 'returns http success for any authenticated user' do
      get project_preview_index_path(project)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'authentication' do
    before { logout }

    it 'requires authentication' do
      get project_preview_index_path(project)
      expect(response).to redirect_to(login_path)
    end
  end
end 