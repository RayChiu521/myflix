Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'followships#index'

  resources :videos, only: [:index, :show] do
    collection do
      post 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:show, :create]
  resources :categorys, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :followships, only: [:create, :destroy]

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]

  resources :password_resets, only: [:show, :create]

  get 'invitation', to: 'invitations#new'
  resources :invitations, only: [:create]

  get 'expired_token', to: 'pages#expired_token'
  root 'pages#front'
end
