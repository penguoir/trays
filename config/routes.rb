require 'sidekiq/web'

Rails.application.routes.draw do
  draw :madmin

  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'

    namespace :madmin do
      resources :impersonates do
        post :impersonate, on: :member
        post :stop_impersonating, on: :collection
      end
    end
  end

  resources :notifications, only: [:index]
  resources :announcements, only: [:index]

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root to: 'home#index'

  resources :inbox_items do
    member do
      post :processed
      post :pin
    end

    collection do
      post :unpin
    end
  end

  resources :projects
  resources :next_actions do
    collection do
      get :completed
    end

    member do
      post :complete
      post :incomplete
    end
  end
end
