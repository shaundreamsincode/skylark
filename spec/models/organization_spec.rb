require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it 'has many organization_memberships' do
      organization = create(:organization)
      membership1 = organization.organization_memberships.create!(user: create(:user))
      membership2 = organization.organization_memberships.create!(user: create(:user))
      expect(organization.organization_memberships).to include(membership1, membership2)
    end

    it 'has many users through organization_memberships' do
      organization = create(:organization)
      user1 = create(:user)
      user2 = create(:user)
      organization.organization_memberships.create!(user: user1)
      organization.organization_memberships.create!(user: user2)
      expect(organization.users).to include(user1, user2)
    end

    it 'has many projects' do
      organization = create(:organization)
      project1 = create(:project, organization: organization)
      project2 = create(:project, organization: organization)
      expect(organization.projects).to include(project1, project2)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      org = build(:organization)
      expect(org).to be_valid
    end

    it 'requires a name' do
      org = build(:organization, name: nil)
      expect(org).not_to be_valid
      expect(org.errors[:name]).to include("can't be blank")
    end

    it 'requires a unique name' do
      create(:organization, name: 'UniqueOrg')
      org = build(:organization, name: 'UniqueOrg')
      expect(org).not_to be_valid
      expect(org.errors[:name]).to include('has already been taken')
    end
  end

  describe 'factory' do
    it 'creates a valid organization' do
      org = create(:organization)
      expect(org).to be_persisted
      expect(org.name).to be_present
    end

    it 'creates an organization with members' do
      org = create(:organization, :with_members)
      expect(org.organization_memberships.count).to eq(3)
    end
  end
end 