require 'rails_helper'

RSpec.describe InformationRequest, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      project = create(:project)
      info_request = create(:information_request, project: project)
      expect(info_request.project).to eq(project)
    end

    it 'belongs to a user' do
      user = create(:user)
      info_request = create(:information_request, user: user)
      expect(info_request.user).to eq(user)
    end

    it 'has many information_request_responses' do
      info_request = create(:information_request)
      response1 = info_request.information_request_responses.create!(content: 'Response 1')
      response2 = info_request.information_request_responses.create!(content: 'Response 2')
      expect(info_request.information_request_responses).to include(response1, response2)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      info_request = build(:information_request)
      expect(info_request).to be_valid
    end

    it 'requires a title' do
      info_request = build(:information_request, title: nil)
      expect(info_request).not_to be_valid
      expect(info_request.errors[:title]).to include("can't be blank")
    end

    it 'requires a description' do
      info_request = build(:information_request, description: nil)
      expect(info_request).not_to be_valid
      expect(info_request.errors[:description]).to include("can't be blank")
    end
  end

  describe 'token generation' do
    it 'generates a unique token before create' do
      info_request = create(:information_request)
      expect(info_request.token).to be_present
      expect(info_request.token.length).to be >= 20
    end

    it 'does not overwrite an existing token' do
      info_request = build(:information_request, token: 'customtoken123')
      info_request.save!
      expect(info_request.token).to eq('customtoken123')
    end
  end

  describe 'factory' do
    it 'creates a valid information_request' do
      info_request = create(:information_request)
      expect(info_request).to be_persisted
      expect(info_request.title).to be_present
      expect(info_request.description).to be_present
      expect(info_request.project).to be_present
      expect(info_request.user).to be_present
    end
  end
end 