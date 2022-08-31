Rails.application.routes.draw do
  resources :tasks, :users, :labels
  resources :sessions, only: [:new, :create, :destroy]
  root "sessions#new"
  namespace :admin do
    resources :users
  end
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'  
  # Fo on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
