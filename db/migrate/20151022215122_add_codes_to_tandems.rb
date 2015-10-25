class AddCodesToTandems < ActiveRecord::Migration
  def change
  	add_column :tandems, :inviter_code, :string, :default => nil
  	add_column :tandems, :invitee_code, :string, :default => nil
  end
end
