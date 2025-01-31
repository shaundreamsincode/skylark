class SuperAdmin::OrganizationsController < SuperAdmin::SuperAdminController
  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to super_admin_organizations_path, notice: "Organization created successfully."
    else
      render :new
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(organization_params)
      redirect_to super_admin_organizations_path, notice: "Organization updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    redirect_to super_admin_organizations_path, notice: "Organization deleted successfully."
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
