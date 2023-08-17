Rails.application.routes.draw do
 resources :users do
    post :login, on: :collection
 end
end
