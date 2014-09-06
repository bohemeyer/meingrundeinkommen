class AddUserRefToChances < ActiveRecord::Migration
  def change
    add_reference :chances, :user, index: true
  end
end
