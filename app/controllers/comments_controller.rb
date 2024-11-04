class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = @current_user

    if @comment.save
      redirect_to @post, notice: 'Comment was added successfully.'
    else
      @comments = @post.comments.order(created_at: :desc)
      render 'posts/show', status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end