Subwire::Application.routes.draw do
	mount Ckeditor::Engine => '/ckeditor'

	# Devise
	devise_for :users, :controllers => {
		:registrations => "registrations",
		:confirmations => "confirmations"
	}


	# Unset current instance
	get "instances/unset", :to => "instances#unset"
	get "instances/all", :to => "instances#all"

	# Instances
	resources :instances

	# Users
	get "users/finish", :to => "users#finish"
	post "users/finish", :to => "users#finish_save"
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

	# Inactive user
	get "inactive", :to => "home#inactive"

	# Start page
	get "home/index"
	root :to => "home#index"
end
