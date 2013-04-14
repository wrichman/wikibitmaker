Wikibitmaker::Application.routes.draw do

	get "/about" => "application#about"

  root :to => 'sessions#new'

  resources :sessions
  resources :articles do
    get "/discussion" => "discussions#show"
    post "discussion/comments" => "comments#create"
  end
end
