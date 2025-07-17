require 'rails_helper'

RSpec.describe InformationRequestResponse, type: :model do
  describe 'associations' do
    it 'belongs to an information_request' do
      info_request = create(:information_request)
      response = create(:information_request_response, information_request: info_request)
      expect(response.information_request).to eq(info_request)
    end
  end

  describe 'attributes' do
    it 'has content' do
      response = create(:information_request_response, content: 'Test response content')
      expect(response.content).to eq('Test response content')
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      response = build(:information_request_response)
      expect(response).to be_valid
    end

    it 'requires an information_request' do
      response = build(:information_request_response, information_request: nil)
      expect(response).not_to be_valid
      expect(response.errors[:information_request]).to include('must exist')
    end
  end

  describe 'factory' do
    it 'creates a valid information_request_response' do
      response = create(:information_request_response)
      expect(response).to be_persisted
      expect(response.information_request).to be_present
      expect(response.content).to be_present
    end
  end
end 