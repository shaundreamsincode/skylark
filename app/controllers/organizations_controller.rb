class OrganizationsController < ApplicationController
  before_action :require_login

  def show
    @organization = Organization.find(params[:id])
    @projects = @organization.projects
  end
end
