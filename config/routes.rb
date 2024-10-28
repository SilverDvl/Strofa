Rails.application.routes.draw do
  namespace :admin do
    resources :articles
    resources :authors
    resources :books
    # resources :book_authors
    # resources :book_genres
    resources :comments
    resources :genres
    resources :reviews
    resources :users
    resources :pages
    resources :contacts
    resources :admin_users

    # AdminUser authentication
    # resources :sessions, only: [ :new, :create, :destroy ]
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    root to: "books#index"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :contacts, only: [ :create ] do
    get :success, on: :collection
  end

  get "/about" => "pages#about"
  get "/promo" => "pages#promo"

  root "pages#about"
end
