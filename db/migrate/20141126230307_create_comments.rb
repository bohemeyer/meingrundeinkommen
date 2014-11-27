class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.text :text
      t.string :static_name
      t.string :static_avatar
      t.string :name
      t.references :commentable, polymorphic: true
      t.timestamps
    end
  end
end
