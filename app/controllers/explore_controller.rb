class ExploreController < ApplicationController
  def index
    @projects = Project.all
  end
end
