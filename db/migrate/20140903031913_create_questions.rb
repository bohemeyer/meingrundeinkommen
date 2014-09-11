class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.text :answer
      t.string :category

      t.timestamps
    end
  end
end
