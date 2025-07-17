require 'rails_helper'

RSpec.describe 'Organizations', type: :request do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization, user: user) }

  before do
    login_as(user)
  end

  describe 'GET /organizations/:id' do
    context 'when organization exists' do
      it 'returns http success' do
        get organization_path(organization)
        expect(response).to have_http_status(:success)
      end

      it 'assigns the organization' do
        get organization_path(organization)
        expect(assigns(:organization)).to eq(organization)
      end

      it 'assigns the organization projects' do
        project # Create the project
        get organization_path(organization)
        expect(assigns(:projects)).to include(project)
      end

      it 'does not include projects from other organizations' do
        other_organization = create(:organization)
        other_project = create(:project, organization: other_organization, user: user)
        project # Create the project for the target organization
        
        get organization_path(organization)
        
        expect(assigns(:projects)).to include(project)
        expect(assigns(:projects)).not_to include(other_project)
      end
    end

    context 'when organization does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get organization_path(999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication' do
      get organization_path(organization)
      expect(response).to redirect_to(login_path)
    end
  end
end 