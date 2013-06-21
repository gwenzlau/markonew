class PostsController < ApplicationController 
  #commented out only for developmnet
  #before_filter :authenticate_user!

respond_to :html, :json, :xml

  def index
    @posts = Post.order("created_at desc").all(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def new
    @post = current_user.posts.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
   # this is what it used to be to make it work on web but not iOS
   # @post = current_user.posts.new(params[:post])
    @post = Post.new(params[:post])
    respond_with(@post)
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Mark was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = current_user.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Success!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
