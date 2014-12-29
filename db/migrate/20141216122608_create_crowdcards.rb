class CreateCrowdcards < ActiveRecord::Migration
  def change
    create_table :crowdcards do |t|
      t.references :user
      t.text :first_name
      t.text :last_name
      t.text :street
      t.text :house_number
      t.text :zip_code
      t.text :city
      t.text :country, :default => 'de'
      t.integer :number_of_cards, :default => 1
      t.timestamps
    end
  end
end
