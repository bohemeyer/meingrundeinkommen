class ChangeCodeInChances < ActiveRecord::Migration
  def up
    change_column :chances, :code, :string
  end

  def down
    change_column :chances, :code, :integer
  end
end
