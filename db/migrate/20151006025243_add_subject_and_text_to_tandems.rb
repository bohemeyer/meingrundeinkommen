class AddSubjectAndTextToTandems < ActiveRecord::Migration
  def change
    add_column :tandems, :invitee_email_subject, :text
    add_column :tandems, :invitee_email_text, :text
  end
end
