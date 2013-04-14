class DiscussionsController < ApplicationController
  def show
    @discussion = Article.find(params[:article_id]).discussion
    @comments   = @discussion.comments.order('comments.created_at ASC').all
    @comment    = @discussion.comments.build
  end
end
