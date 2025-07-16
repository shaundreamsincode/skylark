require 'rails_helper'

RSpec.describe ProjectMembership, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      project = create(:project)
      membership = create(:project_membership, project: project)
      expect(membership.project).to eq(project)
    end

    it 'belongs to a user' do
      user = create(:user)
      membership = create(:project_membership, user: user)
      expect(membership.user).to eq(user)
    end
  end

  describe 'enum status' do
    it 'defaults to pending' do
      membership = create(:project_membership)
      expect(membership.status).to eq('pending')
    end

    it 'can be approved' do
      membership = create(:project_membership, status: :approved)
      expect(membership.status).to eq('approved')
    end

    it 'can be rejected' do
      membership = create(:project_membership, status: :rejected)
      expect(membership.status).to eq('rejected')
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      membership = build(:project_membership)
      expect(membership).to be_valid
    end

    it 'requires a project' do
      membership = build(:project_membership, project: nil)
      expect(membership).not_to be_valid
      expect(membership.errors[:project]).to include('must exist')
    end

    it 'requires a user' do
      membership = build(:project_membership, user: nil)
      expect(membership).not_to be_valid
      expect(membership.errors[:user]).to include('must exist')
    end
  end

  describe 'factory' do
    it 'creates a valid project_membership' do
      membership = create(:project_membership)
      expect(membership).to be_persisted
      expect(membership.project).to be_present
      expect(membership.user).to be_present
    end
  end
end 