class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  include SocketHelpers::ControllerHelpers

  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:current_user])
    if session[:current_user] && !(@current_user)
      session[:current_user] = nil
    end
    @current_user
  end
  
end
