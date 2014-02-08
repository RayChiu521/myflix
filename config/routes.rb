Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'followships#index'
  get 'forgot_password', to: 'users#forgot_password'
  post 'email_password_token', to: 'users#email_password_token'
  get 'confirm_password_reset', to: 'pages#confirm_password_reset'
  get 'reset_password/:id', to: 'users#reset_password', as: 'reset_password'
  post 'save_password', to: 'users#save_password'
  get 'invalid_token', to: 'pages#invalid_token'

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

  root 'pages#front'
end
