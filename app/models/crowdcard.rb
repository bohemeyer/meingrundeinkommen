class Crowdcard < ActiveRecord::Base

	require 'csv'

	validates_presence_of :last_name, :street, :house_number, :city, :zip_code, :country

	belongs_to :user



	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |product|
	      csv << product.attributes.values_at(*column_names)
	    end
	  end
	end



end
