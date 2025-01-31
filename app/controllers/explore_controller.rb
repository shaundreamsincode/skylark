class ExploreController < ApplicationController
  def index
    @categories = Category.all
  end
end
