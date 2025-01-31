class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @projects = @tag.projects
  end
end
