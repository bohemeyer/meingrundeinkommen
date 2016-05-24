class Code < ActiveRecord::Base


	def self.get
		code = self.where(:used => false).order(id: :asc).limit(1).lock(true).first
		code.used = true
		code.save!
		return code.code
	end

	def self.get_random(limit = 100000)
		code = self.where(:used => false, :id => 0..limit).lock(true).sample
		code.used = true
		code.save!
		return code.code
	end

	def self.last
		self.where(:used => true).order(id: :desc).limit(1).first
	end

end
