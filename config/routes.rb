Subwire::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'


  # Devise
  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }


  # Channels
  resources :channels do
    # Links
    get 'links/move_position_up/:id',
      to: "channels/links#move_position_up", as: "link_up"

    get 'links/move_position_dn/:id',
      to: "channels/links#move_position_dn", as: "link_down"

    resources :links, controller: "channels/links"


    # Messages and comments
    resources :messages, controller: "channels/messages" do
      resources :comments, only: [:index, :create, :update, :destroy],
        controller: "channels/messages/comments"

      get 'comments/load_all',
        to: "channels/messages/comments#load_all",
        as: "comments_load_all"

      post 'mark_as_important', to: "channels/messages#mark_as_important"
    end


    # Availability Tool
    post "availability", to: "channels/availabilities#set"


    # Relationships
    resources :relationships, controller: "channels/relationships"


    # Wiki
    get 'wiki/home', to: "channels/pages#home"
    resources :wiki, controller: "channels/pages"
  end


  # Notifications
  resources :notifications, only: [:index, :show, :destroy], controller: "users/notifications"


  # Users
  get "users/finish", to: "users#finish"
  post "users/finish", to: "users#finish_save"
  get "users/user_box", to: "users#user_box"
  resources :users, only: [:index, :show, :edit, :update, :destroy]


  # Misc
  get "inactive", to: "home#inactive"
  get "virgin", to: "home#virgin"
  get "about", to: "home#about"

  scope "/:locale" do
    get "/integration", to: "home#integration"
  end


  # Start page
  get "home/index"
  root to: "home#index"
end
