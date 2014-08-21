class CreateUserWishes < ActiveRecord::Migration
  def change
    create_table :user_wishes do |t|
      t.text :story
      t.references :user
      t.references :wish

      t.timestamps
    end
  end
end
