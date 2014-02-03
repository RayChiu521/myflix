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

  resources :videos, only: [:index, :show] do
    collection do
      post 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:show, :create]
  resources :categorys, only: [:show]
  resources :queue_items, only: [:create, :destroy]

  root 'pages#front'
end
