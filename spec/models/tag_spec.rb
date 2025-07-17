require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
    it 'has many project_tags' do
      tag = create(:tag)
      project_tag1 = tag.project_tags.create!(project: create(:project))
      project_tag2 = tag.project_tags.create!(project: create(:project))
      expect(tag.project_tags).to include(project_tag1, project_tag2)
    end

    it 'has many projects through project_tags' do
      tag = create(:tag)
      project1 = create(:project)
      project2 = create(:project)
      tag.project_tags.create!(project: project1)
      tag.project_tags.create!(project: project2)
      expect(tag.projects).to include(project1, project2)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it 'requires a name' do
      tag = build(:tag, name: nil)
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end

    it 'requires a unique name' do
      create(:tag, name: 'UniqueTag')
      tag = build(:tag, name: 'UniqueTag')
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include('has already been taken')
    end
  end

  describe 'factory' do
    it 'creates a valid tag' do
      tag = create(:tag)
      expect(tag).to be_persisted
      expect(tag.name).to be_present
    end
  end
end 