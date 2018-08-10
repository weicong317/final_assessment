Rails.application.routes.draw do
  root "homepage#index"
  
  resources :user, controller: "users"
  resources :sessions
  resources :messages

  get "/auth/:provider/callback" => "sessions#create_with_omniauth"
end
