class AddActiveFlagToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :confirmed, :boolean, :default => false
  end
end
