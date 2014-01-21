Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'

  resources :videos, only: [:show] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  root 'home#index'
end
