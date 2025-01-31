class Projects::NotesController < Projects::ApplicationController
  def index
    @notes = @project.notes.order(created_at: :desc)
  end

  def show
    @note = @project.notes.find(params[:id])
  end

  def new
    @note = @project.notes.new
  end

  def create
    @note = @project.notes.new(note_params.merge(user: current_user))
    if @note.save
      redirect_to project_notes_path(@project), notice: "Note added successfully."
    else
      flash[:alert] = "Failed to add note."
      render :new
    end
  end

  private

  def note_params
    params.require(:project_note).permit(:content, :entry_type, :title)
  end
end
