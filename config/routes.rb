Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  resources :videos, only: [:index, :show] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  resources :users, only: [:create]

  root 'pages#front'
end
