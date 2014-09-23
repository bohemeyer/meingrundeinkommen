class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.reference :user
      t.string :firstname
      t.string :lastname
      t.float :amount
      t.float :amount_internal
      t.string :email
      t.string :company
      t.string :street
      t.string :zip
      t.string :city
      t.string :country
      t.string :payment_method
      t.text :comment
      t.boolean :anonymous
      t.boolean :recurring
      t.string :recurring_period
      t.string :string

      t.timestamps
    end
  end
end
