class PagesController < ApplicationController
  def sample
  end
  def main
    render "main"
  end
  def new
  end
  def create_user
    websocket_response(User.create, "create")
    render text: ""
  end
  def create
    ticker = Ticker.create(ticker_params)
    ticker.update(output: ticker.create_and_execute_file)
    flash[:message] = "created ticker"
    redirect_to "/"
  end

  private; def ticker_params; params.permit(:name, :content, :interval); end

end
