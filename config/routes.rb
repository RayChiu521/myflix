Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'home#index'
end
