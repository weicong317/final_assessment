Rails.application.routes.draw do
  root "homepage#index"
  resources :user, controller: "users"
  resources :sessions
end
