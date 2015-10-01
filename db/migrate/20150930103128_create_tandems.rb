class CreateTandems < ActiveRecord::Migration
  def change
    create_table :tandems do |t|
      t.integer  :inviter_id
      t.integer  :invitee_id, :default => nil
      t.string   :invitee_name
      t.string   :invitee_email
      t.string   :invitation_token, :default => nil
      t.datetime :invitation_accepted_at
      t.string   :purpose
      t.boolean  :invitee_participates
      t.timestamps
    end
    add_index :tandems, :invitation_token, :unique => true
  end
end
