class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.string :nickname
      t.string :email
      t.string :firstname
      t.string :lastname
      t.float :amount_total
      t.float :amount_internal
      t.float :amount_for_income
      t.string :company
      t.string :street
      t.string :zip
      t.string :city
      t.string :country
      t.string :payment_method
      t.boolean :payment_completed
      t.text :comment
      t.boolean :anonymous
      t.boolean :recurring
      t.timestamps
    end
  end
end