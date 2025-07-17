require 'rails_helper'

RSpec.describe 'Community', type: :request do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }

  before do
    login_as(user)
  end

  describe 'GET /community' do
    it 'returns http success' do
      get community_index_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns all organizations' do
      organization # Create the organization
      get community_index_path
      expect(assigns(:organizations)).to include(organization)
    end

    it 'assigns all users' do
      user # Create the user
      get community_index_path
      expect(assigns(:users)).to include(user)
    end

    it 'includes multiple organizations' do
      organization1 = create(:organization)
      organization2 = create(:organization)
      
      get community_index_path
      
      expect(assigns(:organizations)).to include(organization1, organization2)
    end

    it 'includes multiple users' do
      user1 = create(:user)
      user2 = create(:user)
      
      get community_index_path
      
      expect(assigns(:users)).to include(user1, user2)
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication' do
      get community_index_path
      expect(response).to redirect_to(login_path)
    end
  end
end 