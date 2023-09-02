require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post :login
          post :logout
        end
      end
    end
  end

  resources :password_resets, only: [] do
    collection do
      post :send_reset_password_email
    end
    member do
      get :reset_password
      post :update_password
    end
  end
end