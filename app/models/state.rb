class State < ActiveRecord::Base
  searchable do
    text :text
  end

  has_many :state_users, :dependent => :destroy
  has_many :users, through: :state_users

  validates_uniqueness_of :text, :case_sensitive => false

end
