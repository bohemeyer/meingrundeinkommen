class AddSentFirstNotificationAtToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :sent_first_notification_at, :date, :default => nil
  end
end
