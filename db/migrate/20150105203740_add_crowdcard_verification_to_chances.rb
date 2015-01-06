class AddCrowdcardVerificationToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :crowdcard_code, :string, :default => nil
  end
end
