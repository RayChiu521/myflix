Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'genre', to: 'categories#index'

  resources :videos, only: [:show]

  root 'home#index'
end
