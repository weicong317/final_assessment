Rails.application.routes.draw do
  root "homepage#index"
  
  get "/messages/orderByOldToNew" => "messages#old_to_new"
  get "/messages/orderByWithComment" => "messages#with_comment"
  get "/messages/orderByWithImage" => "messages#with_image"
  get "/messages/search" => "messages#search"
  post "/messages/delete_request/:id" => "messages#delete_request"
  put "/messages/report/:id" => "messages#report"

  get "admin/dashboard" => "admin#dashboard"

  
  resources :user, controller: "users"
  resources :sessions
  resources :messages do
    resources :reports
  end
  resources :comments

  get "/auth/:provider/callback" => "sessions#create_with_omniauth"
end
