class AddAddressToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :user_zip, :string
    add_column :payments, :user_city, :string
  end
end
