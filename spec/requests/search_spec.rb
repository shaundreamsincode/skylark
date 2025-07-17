require 'rails_helper'

RSpec.describe 'Search', type: :request do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe 'GET /search' do
    context 'with no query' do
      it 'returns http success' do
        get search_index_path
        expect(response).to have_http_status(:success)
      end

      it 'assigns empty query' do
        get search_index_path
        expect(assigns(:query)).to be_blank
      end

      it 'does not assign search results' do
        get search_index_path
        expect(assigns(:projects)).to be_nil
        expect(assigns(:organizations)).to be_nil
        expect(assigns(:tags)).to be_nil
        expect(assigns(:categories)).to be_nil
      end
    end

    context 'with empty query' do
      it 'returns http success' do
        get search_index_path, params: { q: '' }
        expect(response).to have_http_status(:success)
      end

      it 'assigns empty query' do
        get search_index_path, params: { q: '' }
        expect(assigns(:query)).to be_blank
      end
    end

    context 'with whitespace-only query' do
      it 'returns http success' do
        get search_index_path, params: { q: '   ' }
        expect(response).to have_http_status(:success)
      end

      it 'assigns empty query after stripping' do
        get search_index_path, params: { q: '   ' }
        expect(assigns(:query)).to be_blank
      end
    end

    context 'with project search query' do
      it 'finds matching projects' do
        project = create(:project, title: 'Test Project', user: user)
        
        get search_index_path, params: { q: 'Test Project' }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:query)).to eq('Test Project')
        expect(assigns(:projects)).to include(project)
      end

      it 'finds projects with partial matches' do
        project = create(:project, title: 'Test Project', user: user)
        
        get search_index_path, params: { q: 'Test' }
        
        expect(assigns(:projects)).to include(project)
      end

      it 'is case insensitive' do
        project = create(:project, title: 'Test Project', user: user)
        
        get search_index_path, params: { q: 'test project' }
        
        expect(assigns(:projects)).to include(project)
      end

      it 'does not find non-matching projects' do
        project = create(:project, title: 'Test Project', user: user)
        other_project = create(:project, title: 'Other Project', user: user)
        
        get search_index_path, params: { q: 'Test Project' }
        
        expect(assigns(:projects)).to include(project)
        expect(assigns(:projects)).not_to include(other_project)
      end
    end

    context 'with organization search query' do
      it 'finds matching organizations' do
        organization = create(:organization, name: 'Test Organization')
        
        get search_index_path, params: { q: 'Test Organization' }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:query)).to eq('Test Organization')
        expect(assigns(:organizations)).to include(organization)
      end

      it 'finds organizations with partial matches' do
        organization = create(:organization, name: 'Test Organization')
        
        get search_index_path, params: { q: 'Test' }
        
        expect(assigns(:organizations)).to include(organization)
      end

      it 'is case insensitive' do
        organization = create(:organization, name: 'Test Organization')
        
        get search_index_path, params: { q: 'test organization' }
        
        expect(assigns(:organizations)).to include(organization)
      end
    end

    context 'with tag search query' do
      it 'finds matching tags' do
        tag = create(:tag, name: 'Test Tag')
        
        get search_index_path, params: { q: 'Test Tag' }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:query)).to eq('Test Tag')
        expect(assigns(:tags)).to include(tag)
      end

      it 'finds tags with partial matches' do
        tag = create(:tag, name: 'Test Tag')
        
        get search_index_path, params: { q: 'Test' }
        
        expect(assigns(:tags)).to include(tag)
      end

      it 'is case insensitive' do
        tag = create(:tag, name: 'Test Tag')
        
        get search_index_path, params: { q: 'test tag' }
        
        expect(assigns(:tags)).to include(tag)
      end
    end

    context 'with category search query' do
      it 'finds matching categories' do
        category = create(:category, name: 'Test Category')
        
        get search_index_path, params: { q: 'Test Category' }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:query)).to eq('Test Category')
        expect(assigns(:categories)).to include(category)
      end

      it 'finds categories with partial matches' do
        category = create(:category, name: 'Test Category')
        
        get search_index_path, params: { q: 'Test' }
        
        expect(assigns(:categories)).to include(category)
      end

      it 'is case insensitive' do
        category = create(:category, name: 'Test Category')
        
        get search_index_path, params: { q: 'test category' }
        
        expect(assigns(:categories)).to include(category)
      end
    end

    context 'with multi-type search query' do
      it 'finds matches across all types' do
        project = create(:project, title: 'Test Project', user: user)
        organization = create(:organization, name: 'Test Organization')
        tag = create(:tag, name: 'Test Tag')
        category = create(:category, name: 'Test Category')
        
        get search_index_path, params: { q: 'Test' }
        
        expect(assigns(:projects)).to include(project)
        expect(assigns(:organizations)).to include(organization)
        expect(assigns(:tags)).to include(tag)
        expect(assigns(:categories)).to include(category)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication' do
      get search_index_path, params: { q: 'test' }
      expect(response).to redirect_to(login_path)
    end
  end
end 