Wikibitmaker::Application.routes.draw do

	get "/about" => "application#about"

  root :to => 'sessions#new'

  resources :sessions
  resources :articles
end
