class SessionsController < ApplicationController
	def new
	end

	def create
		@user = login(params[:username], params[:password])
		@article = Article.find_by_title('Home')
		if @user
			redirect_to article_path(@article)
		else
			flash.now[:alert] = "Invalid username or password."
			render :new
		end
	end
end
