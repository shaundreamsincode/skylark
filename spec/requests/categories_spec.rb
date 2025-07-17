require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:tag) { create(:tag) }
  let(:category_tag) { create(:category_tag, category: category, tag: tag) }
  let(:project) { create(:project, user: user) }
  let(:project_tag) { create(:project_tag, project: project, tag: tag) }

  before do
    login_as(user)
  end

  describe 'GET /categories/:id' do
    context 'when category exists' do
      it 'returns http success' do
        get category_path(category)
        expect(response).to have_http_status(:success)
      end

      it 'assigns the category' do
        get category_path(category)
        expect(assigns(:category)).to eq(category)
      end

      it 'assigns the category tags' do
        category_tag # Create the category tag association
        get category_path(category)
        expect(assigns(:tags)).to include(tag)
      end

      it 'assigns projects with category tags' do
        category_tag # Create the category tag association
        project_tag # Create the project tag association
        get category_path(category)
        expect(assigns(:projects)).to include(project)
      end

      it 'does not include projects from other categories' do
        other_category = create(:category)
        other_tag = create(:tag)
        other_project = create(:project, user: user)
        create(:category_tag, category: other_category, tag: other_tag)
        create(:project_tag, project: other_project, tag: other_tag)
        
        category_tag # Create the category tag association
        project_tag # Create the project tag association
        
        get category_path(category)
        
        expect(assigns(:projects)).to include(project)
        expect(assigns(:projects)).not_to include(other_project)
      end

      it 'returns distinct projects' do
        category_tag # Create the category tag association
        project_tag # Create the project tag association
        # Create another project with the same tag
        other_project = create(:project, user: user)
        create(:project_tag, project: other_project, tag: tag)
        
        get category_path(category)
        
        expect(assigns(:projects).count).to eq(2) # Should include both projects
        expect(assigns(:projects)).to include(project, other_project)
      end
    end

    context 'when category does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get category_path(999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication' do
      get category_path(category)
      expect(response).to redirect_to(login_path)
    end
  end
end 