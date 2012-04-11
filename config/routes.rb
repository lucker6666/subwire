BrainDump::Application.routes.draw do
  resources :comments

  resources :links

  resources :users

  resources :articles


  get "home/index"
  root :to => "home#index"

  get "login" => "sessions#new", as: "login"
  post "session" => "sessions#create", as: "sessions"
  delete "logout" => "sessions#destroy"
end
