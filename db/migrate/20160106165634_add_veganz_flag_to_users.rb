class AddVeganzFlagToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :veganz, :boolean, :default => false
  end
end
