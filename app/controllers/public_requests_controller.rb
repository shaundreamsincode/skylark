class PublicRequestsController < ApplicationController
  skip_before_action :require_login

  def show
    @information_request = InformationRequest.find_by(token: params[:token])

    if @information_request.nil? || (@information_request.expires_at.present? && @information_request.expires_at < Time.current)
      render plain: "This request is no longer available.", status: :not_found
      return
    end

    # Only render the view if we have a valid request
    render :show
  end

  def submit
    @information_request = InformationRequest.find_by(token: params[:token])
    return render plain: "Invalid request", status: :not_found if @information_request.nil?

    response = @information_request.responses.create(content: params[:content])

    if response.persisted?
      # Automatically create a ProjectNote (TODO - ADD THE SOURCE [MEMBER ENTRY, RFI])
      ProjectNote.create!(
        project: @information_request.project,
        user: @information_request.user, # Owner of the request
        title: @information_request.title,
        content: response.content,
        entry_type: "report"
      )

      redirect_to root_path, notice: "Your response has been submitted."
    else
      flash[:alert] = "Failed to submit response."
      render :show, status: :unprocessable_entity
    end
  end

  def success
  end
end
