class AddPhoneToChances < ActiveRecord::Migration
  def change
  	add_column :chances, :phone, :string
  end
end
