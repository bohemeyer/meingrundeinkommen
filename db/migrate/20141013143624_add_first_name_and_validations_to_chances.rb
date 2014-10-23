class AddFirstNameAndValidationsToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :first_name, :string
  	add_column :chances, :last_name, :string
  	remove_column :chances, :full_name
  	add_index :chances, [:first_name, :last_name, :dob], :unique => true
  end
end
