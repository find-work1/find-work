class PagesController < ApplicationController
  def sample
  end
  def main
    render "main", layout: false
  end
  def create_user
    websocket_response(User.create, "create")
    render text: ""
  end
end
