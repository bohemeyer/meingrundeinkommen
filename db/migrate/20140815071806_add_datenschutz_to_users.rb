class AddDatenschutzToUsers < ActiveRecord::Migration
  def change
    add_column :users, :datenschutz, :boolean, :default => false
  end
end
