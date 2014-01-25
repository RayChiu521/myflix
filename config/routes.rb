Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'

  resources :videos, only: [:index, :show] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  resources :users, only: [:create]

  root 'pages#front'
end
