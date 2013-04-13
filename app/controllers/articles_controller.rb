class ArticlesController < ApplicationController
	def index
    @article = Article.find_by_title('Home')
	end
end
