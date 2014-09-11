class AddVisibilityToStateUsers < ActiveRecord::Migration
  def change
    add_column :state_users, :visibility, :boolean, :default => false
  end
end
