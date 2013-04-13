class SessionsController < ApplicationController
	def new
	end

	def create
		@user = login(params[:username], params[:password])
		if @user
			redirect_to articles_path, :notice => "Welcome to the exclusive Wiki for Bitmaker Labs."
		else
			flash.now[:alert] = "Invalid username or password."
			render :new
		end
	end
end
