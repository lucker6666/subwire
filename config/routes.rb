BrainDump::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'


	# Devise
  devise_for :users

  get "instances/unset", :to => "instances#unset"
	resources :instances

  resources :users, :only => [:index, :show, :edit, :update, :destroy]
  post "users/add", :to => "users#add"
  get "users/add", :to => "users#add2"

  # Links
  resources :links

  # Articles and comments
  resources :articles do
	  resources :comments, :only => [:create, :update, :destroy]
	end

	# Notifications
	resources :notifications, :only => [:index, :show]

  post "availability", :to => "availabilities#set"

	# Start page
  get "home/index"
  #get '/:locale' => 'home#index'
  root :to => "home#index"
end
