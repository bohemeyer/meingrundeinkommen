class AddCrowdbartestToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :crowdbar_verified, :boolean, :default => false
  	add_column :chances, :ignore_double_chance, :boolean, :default => false
  end
end
