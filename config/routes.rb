Subwire::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'


  # Devise
  devise_for :users, controllers: {
    registrations: "registrations",
    confirmations: "confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }


  # Relationships
  resources :relationships

  # Channels
  resources :channels do
    # Links
    get 'links/move_position_up/:id', to: "links#move_position_up", as: "links_move_position_up"
    get 'links/move_position_dn/:id', to: "links#move_position_dn", as: "links_move_position_dn"

    resources :links

    # Articles and comments
    resources :articles do
      resources :comments, only: [:index, :create, :update, :destroy]
      post 'mark_as_important', to: "articles#ajax_mark_as_important", as: "article_mark_as_important"
    end

    # Notifications
    resources :notifications, only: [:index, :show, :destroy]

    # Availability Tool
    post "availability", to: "availabilities#set"
  end

  # Users
  get "users/finish", to: "users#finish"
  post "users/finish", to: "users#finish_save"
  get "users/user_box", to: "users#user_box"
  resources :users, only: [:index, :show, :edit, :update, :destroy]

  # Misc
  get "inactive", to: "home#inactive"
  get "virgin", to: "home#virgin"

  scope "/:locale" do
    get "/integration", to: "home#integration"
  end

  # Start page
  get "home/index"
  root to: "home#index"
end
