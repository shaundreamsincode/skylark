require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it 'has many category_tags' do
      category = create(:category)
      category_tag1 = category.category_tags.create!(tag: create(:tag))
      category_tag2 = category.category_tags.create!(tag: create(:tag))
      expect(category.category_tags).to include(category_tag1, category_tag2)
    end

    it 'has many tags through category_tags' do
      category = create(:category)
      tag1 = create(:tag)
      tag2 = create(:tag)
      category.category_tags.create!(tag: tag1)
      category.category_tags.create!(tag: tag2)
      expect(category.tags).to include(tag1, tag2)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      category = build(:category)
      expect(category).to be_valid
    end

    it 'requires a name' do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'requires a unique name' do
      create(:category, name: 'UniqueCategory')
      category = build(:category, name: 'UniqueCategory')
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include('has already been taken')
    end
  end

  describe 'factory' do
    it 'creates a valid category' do
      category = create(:category)
      expect(category).to be_persisted
      expect(category.name).to be_present
    end
  end
end 