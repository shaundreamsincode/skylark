class Projects::InformationRequestsController < Projects::ApplicationController
  before_action :set_information_request, only: [:edit, :update]

  def index
    @information_requests = @project.information_requests.order(created_at: :desc)
  end

  def new
    @information_request = @project.information_requests.new
  end

  def create
    @information_request = @project.information_requests.new(information_request_params.merge(user: current_user, token: SecureRandom.hex(10)))

    if @information_request.save
      redirect_to project_information_requests_path(@project), notice: "Information request created successfully."
    else
      flash[:alert] = "Failed to create information request."
      render :new
    end
  end

  def edit
  end

  def update
    if @information_request.update(information_request_params)
      redirect_to project_information_requests_path(@project), notice: "Information request updated successfully."
    else
      flash[:alert] = "Failed to update information request."
      render :edit
    end
  end

  private

  def set_information_request
    @information_request = @project.information_requests.find(params[:id])
  end

  def information_request_params
    params.require(:information_request).permit(:title, :description, :expires_at)
  end
end
