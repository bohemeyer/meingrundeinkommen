class AddCrowdbarProblemToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :crowdbar_not_found, :boolean, :default => false
  end
end
