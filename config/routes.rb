BrainDump::Application.routes.draw do
  devise_for :users

  resources :links

  resources :articles do
	  resources :comments
	end


  get "home/index"
  root :to => "articles#index"
end
