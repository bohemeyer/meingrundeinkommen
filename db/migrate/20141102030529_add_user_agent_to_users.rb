class AddUserAgentToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :browser, :string
  	add_column :users, :os, :string
  end
end
