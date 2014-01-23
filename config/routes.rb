Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'

  resources :videos, only: [:index, :show] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  root 'videos#index'
end
