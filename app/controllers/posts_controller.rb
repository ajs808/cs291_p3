class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_author, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
    # @posts = Post.left_joins(:comments)
    #              .select('posts.*, COUNT(comments.id) as comments_count')
    #              .group('posts.id')
    #              .order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = @current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find_by!(id: params[:id])
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def ensure_author
    unless @current_user && @post.user_id == @current_user.id
      redirect_to @post, alert: 'You can only edit your own posts.'
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end