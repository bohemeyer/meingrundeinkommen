class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :email
      t.references :user
      t.float :amount_total
      t.float :amount_internal
      t.float :amount_for_income
      t.string :bank_owner
      t.string :bank_account
      t.string :bank_code
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
