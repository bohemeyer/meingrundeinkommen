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

	def self.set(current_user,params)
		format = Flag.flagformat(params[:value])
		if existing = current_user.flags.where(:name => params[:name]).first
			existing.update_attribute(format,params[:value])
			existing.update_attribute(:value_boolean, true)  if format != :value_boolean && params[:value]
			existing.update_attribute(:value_boolean, false) if format != :value_boolean && !params[:value]
		else
			existing = current_user.flags.create(:name => params[:name], format => params[:value])
			existing.update_attribute(:value_boolean, true)  if format != :value_boolean && params[:value]
			existing.update_attribute(:value_boolean, false) if format != :value_boolean && !params[:value]
		end
		existing
	end

	def self.increment(current_user,params)
		old = current_user.flags.where(:name => params[:name]).first
	  	params[:value] = old ? old.value_integer + 1 : 1
	  	self.set(current_user,params)
	end

	def display
		return self.value_integer unless self.value_integer.nil?
		return self.value_text    unless self.value_text.nil?
		return self.value_boolean unless self.value_boolean.nil?
		return self.value_date    unless self.value_date.nil?
	end



end
