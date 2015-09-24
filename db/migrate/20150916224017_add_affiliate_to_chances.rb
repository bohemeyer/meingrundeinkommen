class AddAffiliateToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :affiliate, :integer, :default => nil
  end
end
