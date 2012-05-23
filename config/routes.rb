BrainDump::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'


	# Devise
  devise_for :users

  scope "(:locale)", locale: /en|de/ do
    get "instances/unset", :to => "instances#unset"
  	resources :instances

    resources :users

    # Links
    resources :links

    # Articles and comments
    resources :articles do
  	  resources :comments, :only => [:create, :update, :destroy]
  	end

  	# Notifications
  	resources :notifications, :only => [:index, :show]

    post "availability", :to => "availabilities#set"
  end

	# Start page
  get "home/index"
  get '/:locale' => 'home#index'
  root :to => "home#index"
end
