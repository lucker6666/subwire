BrainDump::Application.routes.draw do
  devise_for :users

  resources :comments

  resources :links

  resources :articles


  get "home/index"
  root :to => "home#index"
end
