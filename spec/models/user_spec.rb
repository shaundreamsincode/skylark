require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'requires first_name' do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'requires last_name' do
      user = build(:user, last_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'requires email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires unique email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many projects' do
      user = create(:user)
      project1 = create(:project, user: user)
      project2 = create(:project, user: user)
      
      expect(user.projects).to include(project1, project2)
    end

    it 'has many project_memberships' do
      user = create(:user)
      membership1 = create(:project_membership, user: user)
      membership2 = create(:project_membership, user: user)
      
      expect(user.project_memberships).to include(membership1, membership2)
    end
  end

  describe '#full_name' do
    it 'returns the full name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe 'email downcasing' do
    it 'downcases email before save' do
      user = create(:user, email: 'TEST@EXAMPLE.COM')
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'factory' do
    it 'creates a valid user' do
      user = create(:user)
      expect(user).to be_persisted
      expect(user.email).to be_present
      expect(user.first_name).to be_present
      expect(user.last_name).to be_present
    end

    it 'creates a super admin user' do
      user = create(:user, :super_admin)
      expect(user.super_admin).to be true
    end
  end
end 