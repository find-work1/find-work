class PagesController < ApplicationController
  
      http_basic_authenticate_with(name: ENV["username"], password: ENV["password"], except: [:update_output])


  def update_output
    ticker = Ticker.find_by(id: params[:id])
    ticker ||= Ticker.find_by(name: params[:name])
    if params[:password] == ENV["password"]
      output = params[:output]
    else
      output = "Password not supplied to /update_output"
    end
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
    @ticker = Ticker.find_by(id: params[:id])
  end
  def create_user
    websocket_response(User.create, "create")
    render text: ""
  end
  def create
    ticker = Ticker.find_by(id: params[:id]) || Ticker.new
    ticker.update(ticker_params)
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
