class AddMediacoverageToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :mediacoverage, :boolean, :default => false
  end
end
