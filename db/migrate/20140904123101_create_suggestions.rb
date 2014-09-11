class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :email
      t.text :initial_wishes

      t.timestamps
    end
  end
end
