class Crowdcard < ActiveRecord::Base

	validates_presence_of :last_name, :street, :house_number, :city, :zip_code, :country

	belongs_to :user

end
