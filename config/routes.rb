# require "resque_web"

Rails.application.routes.draw do

  # mount ResqueWeb::Engine => "/resque_web"
# resque_web_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
# constraints resque_web_constraint do
#   mount ResqueWeb::Engine => "/resque_web"
# end

  resources :users
  root "pages#main"
  get "sample", to: "pages#sample"
  get "new", to: "pages#new"
  get "create_user", to: "pages#create_user"
  get "create", to: "pages#create"
  get "start", to: "pages#start"
  get "kill", to: "pages#kill"
  get "killall", to: "pages#killall"
  get "destroy", to: "pages#destroy"
  get "update_output", to: "pages#update_output"
  get "auth", to: "pages#auth"
  get "register", to: "pages#register"
  get "login", to: "pages#login"
  get "logout", to: "pages#logout"
end
