require 'rails_helper'

RSpec.describe ProjectNote, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      project = create(:project)
      note = create(:project_note, project: project)
      expect(note.project).to eq(project)
    end

    it 'belongs to a user' do
      user = create(:user)
      note = create(:project_note, user: user)
      expect(note.user).to eq(user)
    end
  end

  describe 'enum entry_type' do
    it 'defaults to report' do
      note = create(:project_note)
      expect(note.entry_type).to eq('report')
    end

    it 'can be image' do
      note = create(:project_note, entry_type: :image)
      expect(note.entry_type).to eq('image')
    end

    it 'can be dataset' do
      note = create(:project_note, entry_type: :dataset)
      expect(note.entry_type).to eq('dataset')
    end

    it 'can be comment' do
      note = create(:project_note, entry_type: :comment)
      expect(note.entry_type).to eq('comment')
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      note = build(:project_note)
      expect(note).to be_valid
    end

    it 'requires a title' do
      note = build(:project_note, title: nil)
      expect(note).not_to be_valid
      expect(note.errors[:title]).to include("can't be blank").or include("can't be nil")
    end

    it 'requires content' do
      note = build(:project_note, content: nil)
      expect(note).not_to be_valid
      expect(note.errors[:content]).to include("can't be blank").or include("can't be nil")
    end
  end

  describe 'factory' do
    it 'creates a valid project_note' do
      note = create(:project_note)
      expect(note).to be_persisted
      expect(note.title).to be_present
      expect(note.content).to be_present
      expect(note.project).to be_present
      expect(note.user).to be_present
    end
  end
end 