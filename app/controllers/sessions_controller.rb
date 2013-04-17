class SessionsController < ApplicationController
	def new
		if current_user
			redirect_to :articles
		end
	end

	def create
		@user = login(params[:username], params[:password])
		if @user
			redirect_to :articles
		else
			flash.now[:alert] = "Invalid username or password."
			render :new
		end
	end

	def destroy
		logout
		redirect_to :root
	end
end
