class Setting < ActiveRecord::Base


	def self.get(name)
		self.where(:name => name).first.value
	end

end
