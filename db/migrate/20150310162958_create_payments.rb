class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :user_email
      t.references :user
      t.string :user_first_name
      t.string :user_last_name
      t.string :user_street
      t.string :user_street_number
      t.float :amount_total
      t.float :amount_society
      t.float :amount_bge
      t.boolean :accept
      t.string :account_bank
      t.string :account_iban
      t.string :account_bic
      t.boolean :active, :default => true
      t.datetime :activated_at
      t.datetime :paused_at
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
