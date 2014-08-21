class CreateStateUsers < ActiveRecord::Migration
  def change
    create_table :state_users do |t|
      t.text :story
      t.references :user
      t.references :state

      t.timestamps
    end
  end
end
