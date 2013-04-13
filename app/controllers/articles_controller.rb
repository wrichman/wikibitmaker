class ArticlesController < ApplicationController
	before_filter :require_article, only: [:show, :edit, :update]

	def show
	end

	def edit
	end

	def update
		if @article.update_attributes params[:article]
			redirect_to @article, notice: "You've improved the article."
		else
			render :new
		end
	end

	def new
	end

	def create
	end

	protected 

	def require_article
		@article = Article.find params[:id]
	end
end
