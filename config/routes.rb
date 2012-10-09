Subwire::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  # Devise
  devise_for :users, controllers: {
    registrations: "registrations",
    confirmations: "confirmations"
  }


  # Channels
  get "channels/unset", to: "channels#unset"
  get "channels/all", to: "channels#all"
  resources :channels

  # Users
  get "users/finish", to: "users#finish"
  get "ajax/users/load_user_box", to: "users#ajax_load_user_box"
  post "users/finish", to: "users#finish_save"
  resources :users, only: [:index, :show, :edit, :update, :destroy]

  # Relationships
  resources :relationships, only: [:index, :create, :new, :edit, :update, :destroy]

  # Links
  get 'links/move_position_up/:id', to: "links#move_position_up", as: "links_move_position_up"
  get 'links/move_position_dn/:id', to: "links#move_position_dn", as: "links_move_position_dn"

  resources :links

  # Articles and comments
  get 'ajax/comments/load_all_comments/:article_id', to: "comments#ajax_load_all_comments", as: "ajax_comments_load_all_comments"
  post 'ajax/article/mark_as_important', to: "articles#ajax_mark_as_important", as: "ajax_article_mark_as_important"
  resources :articles do
    resources :comments, only: [:create, :update, :destroy]
  end

  # Notifications
  resources :notifications, only: [:index, :show, :destroy]

  # Availability Tool
  post "availability", to: "availabilities#set"

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
