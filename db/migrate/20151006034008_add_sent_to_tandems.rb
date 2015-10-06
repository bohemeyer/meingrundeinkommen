class AddSentToTandems < ActiveRecord::Migration
  def change
  	add_column :tandems, :invitee_email_sent, :datetime, :default => nil
  end
end
