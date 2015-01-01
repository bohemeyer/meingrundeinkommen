class Flag < ActiveRecord::Base

	belongs_to :user

	validates_presence_of :name

	#validates_uniqueness_of :user_id + :name

	def self.flagformat(value)
		return :value_boolean if !!value == value
		return :value_integer if value.is_a? Integer
		return :value_date    if value.is_a? Date
		return :value_text 	  if value.is_a? String
	end

	def display
		return self.value_integer unless self.value_integer.nil?
		return self.value_text    unless self.value_text.nil?
		return self.value_boolean unless self.value_boolean.nil?
		return self.value_date    unless self.value_date.nil?
	end

end
