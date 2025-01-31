class CommunityController < ApplicationController
  def index
    @organizations = Organization.all
    @users = User.all
  end
end
