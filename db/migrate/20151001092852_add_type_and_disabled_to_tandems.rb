class AddTypeAndDisabledToTandems < ActiveRecord::Migration
  def change
  	add_column :tandems, :invitation_type, :string
  	add_column :tandems, :disabled_by, :integer, :default => nil
  end
end
