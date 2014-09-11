class CreateChances < ActiveRecord::Migration
  def change
    create_table :chances do |t|
      t.references :user
      t.string :full_name
      t.date :dob
      t.boolean :is_child
      t.integer :country_id
      t.string :city
      t.boolean :confirmed_publication
      t.integer :code

      t.timestamps
    end
  end
end
