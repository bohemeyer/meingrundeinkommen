class AddUserReferenceToSupports < ActiveRecord::Migration
  def change
  	add_reference :supports, :user
  end
end
