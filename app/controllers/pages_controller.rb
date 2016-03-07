class PagesController < ApplicationController
  def update_output
    ticker = Ticker.find_by(id: params[:id])
    ticker ||= Ticker.find_by(name: params[:name])
    output = params[:output]
    ticker.update(output: output)
    websocket_response(ticker, "update")
    render text: ""
  end
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
    ticker.begin
    flash[:message] = "created ticker"
    redirect_to "/"
  end
  def destroy
    ticker = Ticker.find_by(id: params[:id])
    ticker.kill
    ticker.destroy
    redirect_to "/"
  end

  private; def ticker_params; params.permit(:name, :content, :interval); end

end
