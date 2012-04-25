BrainDump::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

	# Devise
  devise_for :users

  resources :users

  # Links
  resources :links

  # Articles and comments
  resources :articles do
	  resources :comments
	end

	# Notifications
	resources :notifications, :only => [:show]


	# Start page
  get "home/index"
  root :to => "articles#index"
end
