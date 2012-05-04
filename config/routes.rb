BrainDump::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

	# Devise
  devise_for :users

  resources :users

  # Links
  resources :links

  # Articles and comments
  resources :articles do
	  resources :comments, :only => [:create, :update, :destroy]
	end

	# Notifications
	resources :notifications, :only => [:show]

  post "availability", :to => "availabilities#set"

	# Start page
  get "home/index"
  root :to => "articles#index"
end
