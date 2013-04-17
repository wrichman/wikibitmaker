Wikibitmaker::Application.routes.draw do

	get "/about" => "application#about"

  root :to => 'sessions#new'

  resource :session, :only => [:new, :create, :destroy]
  resources :articles do
    get "/discussion" => "discussions#index"
    post "discussion/comments" => "comments#create"
  end
end
