require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      project = build(:project)
      expect(project).to be_valid
    end

    it 'requires a title' do
      project = build(:project, title: nil)
      expect(project).not_to be_valid
      expect(project.errors[:title]).to include("can't be blank").or include("can't be nil")
    end

    it 'requires a user (owner)' do
      project = build(:project, user: nil)
      expect(project).not_to be_valid
      expect(project.errors[:user]).to include("must exist")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      user = create(:user)
      project = create(:project, user: user)
      expect(project.user).to eq(user)
    end

    it 'can optionally belong to an organization' do
      organization = create(:organization)
      project = create(:project, organization: organization)
      expect(project.organization).to eq(organization)
    end

    it 'has many project_memberships' do
      project = create(:project)
      membership1 = create(:project_membership, project: project)
      membership2 = create(:project_membership, project: project)
      expect(project.project_memberships).to include(membership1, membership2)
    end

    it 'has many project_notes' do
      project = create(:project)
      note1 = project.project_notes.create!(user: create(:user), title: 'Note 1', content: 'Content 1')
      note2 = project.project_notes.create!(user: create(:user), title: 'Note 2', content: 'Content 2')
      expect(project.project_notes).to include(note1, note2)
    end

    it 'has many tags through project_tags' do
      project = create(:project)
      tag1 = Tag.create!(name: 'Tag1')
      tag2 = Tag.create!(name: 'Tag2')
      project.tags << [tag1, tag2]
      expect(project.tags).to include(tag1, tag2)
    end
  end

  describe '#members' do
    it 'returns users with approved memberships' do
      project = create(:project)
      approved_user = create(:user)
      pending_user = create(:user)
      create(:project_membership, project: project, user: approved_user, status: 1) # approved
      create(:project_membership, project: project, user: pending_user, status: 0) # pending
      expect(project.members).to eq([approved_user])
    end
  end

  describe 'factory' do
    it 'creates a valid project' do
      project = create(:project)
      expect(project).to be_persisted
      expect(project.title).to be_present
      expect(project.user).to be_present
    end

    it 'creates a private project' do
      project = create(:project, :private)
      expect(project.visibility).to eq(1)
    end

    it 'creates a project with an organization' do
      project = create(:project, :with_organization)
      expect(project.organization).to be_present
    end
  end
end 