Rails.application.routes.draw do
  root "homepage#index"
  
  get "admin/dashboard" => "admin#dashboard"

  resources :user, controller: "users", only: [:new, :create, :show]
  
  get "/auth/:provider/callback" => "sessions#create_with_omniauth"
  
  resources :sessions, only: [:new, :create, :destroy]

  get "/messages/orderByOldToNew" => "messages#old_to_new"
  get "/messages/orderByWithComment" => "messages#with_comment"
  get "/messages/orderByWithImage" => "messages#with_image"
  get "/messages/search" => "messages#search"
  post "/messages/delete_request/:id" => "messages#delete_request"

  resources :messages, except: [:edit] do
    resources :reports, only: [:create, :destroy]
  end

  resources :comments, only: [:create, :destroy]

end
