class UsersController < ApplicationController
	
	#commented out only for developmnet
	#before_filter :authenticate_user!

	respond_to :json, :xml
  def show
  	@user = User.find(params[:id])
    @posts = @user.posts.all
  end

  respond_to :json, :xml
  def index
  	@users = User.all
  end
end
