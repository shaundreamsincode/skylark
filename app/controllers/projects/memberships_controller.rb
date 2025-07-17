class Projects::MembershipsController < Projects::ApplicationController
  skip_before_action :authorize_user, only: [:new, :create]
  def new
  end

  def create
    # TODO - ensure a user can't have multiple memberships on the same project
    @membership = @project.project_memberships.new(user: current_user, request_message: params[:request_message])

    if @membership.save
      redirect_to project_path(@project), notice: "Membership request submitted successfully."
    else
      flash[:alert] = "Failed to submit request."
      render :new
    end
  end

  def update
    @membership = @project.project_memberships.find(params[:id])

    if @membership.update(status: params[:status])
      redirect_to project_path(@project), notice: "Membership status updated successfully."
    else
      flash[:alert] = "Failed to update membership status."
      render :index
    end
  end
end
