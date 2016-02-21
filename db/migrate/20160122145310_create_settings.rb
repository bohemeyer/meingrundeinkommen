class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.boolean :value, :default => false
      t.timestamps
    end
  end
end
