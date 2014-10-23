class AddVotesToQuestions < ActiveRecord::Migration
  def change
  	add_column :questions, :votes, :integer, :default => 1
  end
end
