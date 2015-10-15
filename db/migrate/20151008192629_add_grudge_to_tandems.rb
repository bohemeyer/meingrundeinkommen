class AddGrudgeToTandems < ActiveRecord::Migration
  def change
  	add_column :tandems, :inviter_grudges_invitee_for, :text, :default => nil
  	add_column :tandems, :invitee_grudges_inviter_for, :text, :default => nil
  end
end
