Rails.application.routes.draw do
  root "pages#main"
  get "sample", to: "pages#sample"
end
