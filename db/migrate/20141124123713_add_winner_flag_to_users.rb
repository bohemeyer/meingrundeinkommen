class AddWinnerFlagToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :winner, :integer, :default => false
  end
end
