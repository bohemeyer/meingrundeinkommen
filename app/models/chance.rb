class Chance < ActiveRecord::Base

	belongs_to :user

	validates :confirmed_publication, inclusion: [true]

	validates_presence_of :full_name, :dob

end
