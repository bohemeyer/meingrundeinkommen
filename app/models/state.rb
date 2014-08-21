class State < ActiveRecord::Base
  has_many :state_users, :dependent => :destroy
  has_many :users, through: :state_users
end
