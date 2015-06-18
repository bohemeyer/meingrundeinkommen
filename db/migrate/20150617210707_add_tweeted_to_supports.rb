class AddTweetedToSupports < ActiveRecord::Migration
  def change
    add_column :supports, :tweeted, :boolean
  end
end
