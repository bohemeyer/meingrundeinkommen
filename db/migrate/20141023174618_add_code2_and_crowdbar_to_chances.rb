class AddCode2AndCrowdbarToChances < ActiveRecord::Migration
  def change
  	add_column :users, :has_crowdbar, :boolean, :default => false
  	add_column :chances, :code2, :string
  end
end
