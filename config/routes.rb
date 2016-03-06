Rails.application.routes.draw do
  resources :users
  root "pages#main"
  get "sample", to: "pages#sample"
end
