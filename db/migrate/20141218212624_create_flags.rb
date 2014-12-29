class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.references :user
      t.text :name
      t.boolean :value_boolean
      t.text :value_text
      t.integer :value_integer
      t.date :value_date
      t.timestamps
    end
  end
end
