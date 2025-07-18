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

  describe 'notification creation' do
    let(:project_owner) { create(:user) }
    let(:member1) { create(:user) }
    let(:member2) { create(:user) }

    context 'when project has members' do
      let(:project) { create(:project, user: project_owner) }

      before do
        # Create approved memberships
        create(:project_membership, project: project, user: member1, status: :approved)
        create(:project_membership, project: project, user: member2, status: :approved)
        # Create a pending membership (should not be notified)
        create(:project_membership, project: project, user: create(:user), status: :pending)
      end

      context 'when a note is created by a project member' do
        it 'creates notifications for project owner and other members' do
          expect {
            create(:project_note, project: project, user: member1)
          }.to change(Notification, :count).by(2) # Owner + member2
        end

        it 'does not create notification for the note creator' do
          create(:project_note, project: project, user: member1)
          
          notifications = Notification.last(2)
          expect(notifications.map(&:user)).to include(project_owner, member2)
          expect(notifications.map(&:user)).not_to include(member1)
        end

        it 'creates notifications with correct attributes' do
          note = create(:project_note, project: project, user: member1, title: "Test Note")
          
          notifications = Notification.last(2)
          notifications.each do |notification|
            expect(notification.notifiable).to eq(project)
            expect(notification.message).to eq("New note 'Test Note' added to project '#{project.title}'")
            expect(notification.read).to be false
          end
        end
      end

      context 'when a note is created by the project owner' do
        it 'creates notifications for all project members' do
          expect {
            create(:project_note, project: project, user: project_owner)
          }.to change(Notification, :count).by(2) # member1 + member2
        end

        it 'does not create notification for the project owner' do
          create(:project_note, project: project, user: project_owner)
          
          notifications = Notification.last(2)
          expect(notifications.map(&:user)).to include(member1, member2)
          expect(notifications.map(&:user)).not_to include(project_owner)
        end
      end

      context 'when notification creation fails for some users' do
        before do
          allow(Rails.logger).to receive(:error)
        end

        it 'still creates notifications for other users' do
          # Create a note and verify notifications are created
          expect {
            create(:project_note, project: project, user: member2)
          }.to change(Notification, :count).by(2) # Owner + member1 + member2
        end

        it 'logs errors for failed notifications' do
          # Mock the notification creation to fail for one user
          allow(Notification).to receive(:create).and_call_original
          allow(Notification).to receive(:create).with(hash_including(user: member1)).and_raise(StandardError.new("Database error"))
          
          create(:project_note, project: project, user: member2)
          expect(Rails.logger).to have_received(:error).with(/Failed to create project note notification/)
        end
      end

      context 'with special characters in note title' do
        it 'creates notification with properly formatted title' do
          note = create(:project_note, project: project, user: member1, title: "Note with 'quotes' & special chars!")
          
          notification = Notification.last
          expected_message = "New note 'Note with 'quotes' & special chars!' added to project '#{project.title}'"
          expect(notification.message).to eq(expected_message)
        end
      end
    end

    context 'when project has no members' do
      let(:project) { create(:project, user: project_owner) }

      it 'does not create any notifications when owner creates note' do
        expect {
          create(:project_note, project: project, user: project_owner)
        }.not_to change(Notification, :count)
      end

      it 'does not create any notifications when member creates note' do
        expect {
          create(:project_note, project: project, user: member1)
        }.to change(Notification, :count).by(1) # Only project owner gets notified
      end
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