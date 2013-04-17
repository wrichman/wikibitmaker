class ArticlesController < ApplicationController
	before_filter :require_user
	before_filter :require_article, only: [:show, :edit, :update]

	def index
		@article = Article.find_by_title("Home")
		render :show
	end

	def show
	end

	def edit
	end

	def update
		if @article.update_attributes params[:article]
			redirect_to @article
		else
			render :new
		end
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.create params[:article]
		if @article.save
			redirect_to @article
		else
			render :new
		end
	end

	protected 

	def require_article
		@article = Article.find params[:id]
	end

	def require_user
		unless current_user
			redirect_to new_session_path
		end
	end
end
