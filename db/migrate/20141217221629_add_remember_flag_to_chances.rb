class AddRememberFlagToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :remember_data, :boolean, :default => false
  end
end