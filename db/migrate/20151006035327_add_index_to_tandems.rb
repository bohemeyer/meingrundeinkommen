class AddIndexToTandems < ActiveRecord::Migration
  def change
  	add_index :tandems, [:inviter_id, :invitee_email], unique: true
  end
end
