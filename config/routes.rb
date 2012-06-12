BrainDump::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'


	# Devise
  devise_for :users

  # Unset current instance
  get "instances/unset", :to => "instances#unset"

  # Instances
	resources :instances

	# Users
  resources :users, :only => [:index, :show, :edit, :update, :destroy]

  # Relationships
  resources :relationships, :only => [:index, :create, :new, :edit, :update, :destroy]

  # Links
  resources :links

  # Articles and comments
  resources :articles do
	  resources :comments, :only => [:create, :update, :destroy]
	end

	# Notifications
	resources :notifications, :only => [:index, :show]

	# Availability Tool
  post "availability", :to => "availabilities#set"

	# Start page
  get "home/index"
  root :to => "home#index"
end
