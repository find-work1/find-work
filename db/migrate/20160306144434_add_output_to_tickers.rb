class AddOutputToTickers < ActiveRecord::Migration
  def change
    add_column :tickers, :output, :text
  end
end
