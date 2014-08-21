class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.string :text

      t.timestamps
    end
  end
end
