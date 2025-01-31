class SuperAdmin::OrganizationsController < SuperAdmin::SuperAdminController
  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
    @memberships = @organization.organization_memberships.includes(:user)
    @users = User.all
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

  def add_member
    @organization = Organization.find(params[:id])
    user = User.find(params[:user_id])
    role = params[:role] || "member"

    unless @organization.users.include?(user)
      @organization.organization_memberships.create(user: user, role: role)
      redirect_to super_admin_organization_path(@organization), notice: "User added successfully."
    else
      redirect_to super_admin_organization_path(@organization), alert: "User is already a member."
    end
  end

  def remove_member
    @organization = Organization.find(params[:id])
    membership = @organization.organization_memberships.find_by(user_id: params[:user_id])

    if membership
      membership.destroy
      redirect_to super_admin_organization_path(@organization), notice: "User removed successfully."
    else
      redirect_to super_admin_organization_path(@organization), alert: "User is not a member."
    end
  end

  def update_role
    @organization = Organization.find(params[:id])
    membership = @organization.organization_memberships.find_by(user_id: params[:user_id])

    if membership
      membership.update(role: params[:role])
      redirect_to super_admin_organization_path(@organization), notice: "User role updated successfully."
    else
      redirect_to super_admin_organization_path(@organization), alert: "User is not a member."
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
