Rails.application.routes.draw do
  # get 'articles/index'
  get '/articles', to: 'articles#index'

  root to: 'articles#index'
  get '/articles/:id', to: 'articles#show', as: :article

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end