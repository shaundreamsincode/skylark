class ExploreProjectsController < ApplicationController
  def index
    @projects = Project.all
  end
end
