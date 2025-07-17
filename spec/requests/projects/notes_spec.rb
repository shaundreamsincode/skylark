require 'rails_helper'

RSpec.describe 'Projects::Notes', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:note) { create(:project_note, project: project, user: user) }

  before do
    login_as(user)
  end

  describe 'GET /projects/:project_id/notes' do
    it 'returns http success' do
      get project_notes_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the project notes' do
      note # Create the note
      get project_notes_path(project)
      expect(assigns(:notes)).to include(note)
    end

    it 'orders notes by created_at desc' do
      old_note = create(:project_note, project: project, user: user, created_at: 2.days.ago)
      new_note = create(:project_note, project: project, user: user, created_at: 1.day.ago)
      
      get project_notes_path(project)
      
      expect(assigns(:notes).first).to eq(new_note)
      expect(assigns(:notes).second).to eq(old_note)
    end
  end

  describe 'GET /projects/:project_id/notes/:id' do
    it 'returns http success' do
      get project_note_path(project, note)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the note' do
      get project_note_path(project, note)
      expect(assigns(:note)).to eq(note)
    end
  end

  describe 'GET /projects/:project_id/notes/new' do
    it 'returns http success' do
      get new_project_note_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new note' do
      get new_project_note_path(project)
      expect(assigns(:note)).to be_a_new(ProjectNote)
    end
  end

  describe 'POST /projects/:project_id/notes' do
    let(:valid_params) do
      {
        project_note: {
          title: 'Test Note',
          content: 'Test Content',
          entry_type: 'comment'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new note' do
        expect {
          post project_notes_path(project), params: valid_params
        }.to change(ProjectNote, :count).by(1)
      end

      it 'sets the user and project' do
        post project_notes_path(project), params: valid_params
        
        note = ProjectNote.last
        expect(note.user).to eq(user)
        expect(note.project).to eq(project)
      end

      it 'redirects to index with notice' do
        post project_notes_path(project), params: valid_params
        expect(response).to redirect_to(project_notes_path(project))
        expect(flash[:notice]).to eq('Note added successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          project_note: {
            title: '',
            content: '',
            entry_type: 'comment'
          }
        }
      end

      it 'does not create a note' do
        expect {
          post project_notes_path(project), params: invalid_params
        }.not_to change(ProjectNote, :count)
      end

      it 'renders new template' do
        post project_notes_path(project), params: invalid_params
        expect(response).to render_template(:new)
      end

      it 'sets flash alert' do
        post project_notes_path(project), params: invalid_params
        expect(flash[:alert]).to eq('Failed to add note.')
      end
    end
  end

  describe 'GET /projects/:project_id/notes/export' do
    it 'returns http success' do
      get export_project_notes_path(project), params: { format: 'csv' }
      expect(response).to have_http_status(:success)
    end

    it 'returns csv content type' do
      get export_project_notes_path(project), params: { format: 'csv' }
      expect(response.content_type).to include('text/csv')
    end

    it 'includes csv headers' do
      get export_project_notes_path(project), params: { format: 'csv' }
      expect(response.body).to include('Title,Created By,Created At,Content')
    end

    it 'includes note data in csv' do
      note # Create the note
      get export_project_notes_path(project), params: { format: 'csv' }
      
      expect(response.body).to include(note.title)
      expect(response.body).to include(user.full_name)
      expect(response.body).to include(note.content)
    end

    it 'generates filename with date' do
      get export_project_notes_path(project), params: { format: 'csv' }
      expect(response.headers['Content-Disposition']).to include("project_notes_#{Time.zone.today}.csv")
    end

    it 'orders notes by created_at desc in export' do
      old_note = create(:project_note, project: project, user: user, created_at: 2.days.ago)
      new_note = create(:project_note, project: project, user: user, created_at: 1.day.ago)
      
      get export_project_notes_path(project), params: { format: 'csv' }
      
      # Check that newer note appears first in CSV
      csv_lines = response.body.split("\n")
      expect(csv_lines[1]).to include(new_note.title)
      expect(csv_lines[2]).to include(old_note.title)
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user) }
    let(:other_project) { create(:project, user: other_user) }

    context 'when user is not the project owner or member' do
      before do
        login_as(other_user)
      end

      it 'redirects unauthorized users from index' do
        get project_notes_path(project)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from show' do
        get project_note_path(project, note)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from new' do
        get new_project_note_path(project)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from create' do
        post project_notes_path(project), params: { project_note: { title: 'Test' } }
        expect(response).to redirect_to(root_path)
      end

      it 'redirects unauthorized users from export' do
        get export_project_notes_path(project), params: { format: 'csv' }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'authentication' do
    before do
      logout
    end

    it 'requires authentication for index' do
      get project_notes_path(project)
      expect(response).to redirect_to(login_path)
    end

    it 'requires authentication for show' do
      get project_note_path(project, note)
      expect(response).to redirect_to(login_path)
    end

    it 'requires authentication for export' do
      get export_project_notes_path(project), params: { format: 'csv' }
      expect(response).to redirect_to(login_path)
    end
  end
end 