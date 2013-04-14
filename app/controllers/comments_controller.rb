class CommentsController < ApplicationController
  def create
    @article    = Article.find(params[:article_id])
    @discussion = @article.discussion
    @comment = @discussion.comments.build(:user_id => current_user.id, :text => params[:comment][:text])
    if @comment.save
      redirect_to article_discussion_path(@article, @discussion)
    else
      :new
    end
  end
end
