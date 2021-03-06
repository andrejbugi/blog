Rails.application.routes.draw do

  root to: 'articles#index'

  resources :articles do
    resources :comments
    resources :likes
  end

  resources :personal_messages, only: [:new, :create]
  resources :conversations, only: [:index, :show]

  get '/signup', to: 'users#new'
  resources :users, except: :new

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
