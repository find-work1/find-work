class Ticker < ActiveRecord::Base
  @queue = :file_serve

  def self.perform(ticker_id)
    ticker = Ticker.find(ticker_id)
    ticker.update(output: ticker.create_and_execute_file)
    WebsocketRails["ticker"].trigger("update", Oj.dump(ticker.attributes.merge('record_class')))
    # call this same method again.
    Resque.enqueue_in(ticker.interval.seconds, Ticker, ticker.id)
  end

  def create_and_execute_file
    return "" unless self.content.is_a?(String) && !(self.content.empty?)
    prefix = 'ticker'
    suffix = '.rb'
    t = Tempfile.new [prefix, suffix], "#{Rails.root}/tmp"
    t.write(self.content)
    path = t.path
    t.close
    return `ruby #{t.path}`
  end
end
