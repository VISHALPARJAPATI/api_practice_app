Rails.application.routes.draw do
 resources :users do
    post :login, on: :collection
    post  :logout, on: :collection
 end
end
