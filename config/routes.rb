Rails.application.routes.draw do
  resources :users
  root "pages#main"
  get "sample", to: "pages#sample"
  get "create_user", to: "pages#create_user"
end
