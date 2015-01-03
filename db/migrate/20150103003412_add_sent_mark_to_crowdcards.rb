class AddSentMarkToCrowdcards < ActiveRecord::Migration
  def change
  	add_column :crowdcards, :sent, :date, :default => nil
  end
end
