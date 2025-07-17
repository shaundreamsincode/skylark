require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }
  let(:project) { create(:project, user: user) }
  let(:project_tag) { create(:project_tag, project: project, tag: tag) }

  before do
    login_as(user)
  end

  describe 'GET /tags/:id' do
    context 'when tag exists' do
      it 'returns http success' do
        get tag_path(tag)
        expect(response).to have_http_status(:success)
      end

      it 'assigns the tag' do
        get tag_path(tag)
        expect(assigns(:tag)).to eq(tag)
      end

      it 'assigns the tag projects' do
        project_tag # Create the project tag association
        get tag_path(tag)
        expect(assigns(:projects)).to include(project)
      end

      it 'does not include projects from other tags' do
        other_tag = create(:tag)
        other_project = create(:project, user: user)
        create(:project_tag, project: other_project, tag: other_tag)
        project_tag # Create the project tag association for the target tag
        
        get tag_path(tag)
        
        expect(assigns(:projects)).to include(project)
        expect(assigns(:projects)).not_to include(other_project)
      end
    end

    context 'when tag does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get tag_path(999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication' do
      get tag_path(tag)
      expect(response).to redirect_to(login_path)
    end
  end
end 