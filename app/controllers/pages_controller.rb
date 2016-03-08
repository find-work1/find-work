class PagesController < ApplicationController


  def main
    if current_user
      render "main"
    else
      redirect_to "/auth"
      return false
    end
  end

  def tickers
    render "tickers"
  end

  def auth
    if current_user
      redirect_to "main"
    else
      render "auth"
    end

  end

  def update_output
    ticker = Ticker.find_by(id: params[:id])
    ticker ||= Ticker.find_by(name: params[:name])
    if params[:password] == ENV["password"]
      output = params[:output]
    else
      output = "Password not supplied to /update_output"
    end
    if ticker.process_name
      ticker.update(output: output)
      websocket_response(ticker, "update")
    else
      ticker.update(output: "ERROR - This process is orphaned")
      websocket_response(ticker, "update")
    end
    render text: ""
  end

  def sample
  end

  def kill
    ticker = Ticker.find_by(id: params[:id])
    ticker && ticker.kill
    flash[:message] = "stopped ticker process"
    redirect_to :back
  end

  def killall
    Ticker.killall
    flash[:message] = "stopped all processes"
    redirect_to :back
  end


  def new
    @ticker = Ticker.find_by(id: params[:id])
  end

  def start
    ticker = Ticker.find_by(id: params[:id])
    ticker.kill if ticker.process_name
    ticker.begin
    flash[:message] = "started ticker process"
    redirect_to :back
  end

  def create_user
    websocket_response(User.create, "create")
    render text: ""
  end

  def create
    ticker = Ticker.find_by(id: params[:id]) || Ticker.new
    ticker.kill if ticker.process_name
    ticker.update(ticker_params)
    ticker.begin
    flash[:message] = "Saved ticker"
    redirect_to "/"
  end

  def destroy
    ticker = Ticker.find_by(id: params[:id])
    ticker.kill
    ticker.destroy
    redirect_to "/"
  end

  def register
    if current_user
      redirect_to "/"
      return false
    end
    @user = User.find_by(email: params[:email])
    if @user
      flash[:message] = "there is already an account with this email"
      render "auth"
    else
      user = User.create(user_params)
      session["current_user"] = user.id
      websocket_response(user, "create")
      redirect_to "/"
      return false
    end
  end

  def logout
    @user = current_user
    if @user
      session[:current_user] = nil
      websocket_response(@user, "destroy")
    end
    redirect_to "/"
    return false
  end

  def login
    if current_user
      redirect_to "/"
      return false
    end
    @user = User.find_by(email: params[:email])
    if @user
      if BCrypt::Password.new(@user.password).is_password?(params[:password])
        session[:current_user] = @user.id
        websocket_response(@user, "create")
        redirect_to "/"
        return false
      else
        flash[:message] = "incorrect password"
        render "auth"
        return false
      end
    else
      flash[:message] = "no account was found for that email"
      render "auth"
      return false
    end
  end

  private; def user_params; params.permit(:name, :email, :password); end
  private; def ticker_params; params.permit(:name, :content, :interval); end

end
