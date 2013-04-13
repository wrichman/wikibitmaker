Wikibitmaker::Application.routes.draw do

  root :to => 'sessions#new'

  resources :sessions
  resources :articles
end
