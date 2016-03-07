class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.string :name
      t.text :content
      t.integer :interval
      t.string :process_name
      t.timestamps null: false
    end
  end
end
