require 'rails_helper'

RSpec.describe 'Explore', type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  before do
    login_as(user)
  end

  describe 'GET /explore' do
    it 'returns http success' do
      get explore_index_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns all categories' do
      category # Create the category
      get explore_index_path
      expect(assigns(:categories)).to include(category)
    end

    it 'includes multiple categories' do
      category1 = create(:category)
      category2 = create(:category)
      
      get explore_index_path
      
      expect(assigns(:categories)).to include(category1, category2)
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication' do
      get explore_index_path
      expect(response).to redirect_to(login_path)
    end
  end
end 