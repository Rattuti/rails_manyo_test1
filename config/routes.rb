Rails.application.routes.draw do
  resources :tasks
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  root "sessions#new"
  namespace :admin do
    resources :users
  end
  # Fo on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
