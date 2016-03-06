Rails.application.routes.draw do
  resources :users
  root "pages#main"
  get "sample", to: "pages#sample"
  get "new", to: "pages#new"
  get "create_user", to: "pages#create_user"
end
