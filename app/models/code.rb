class Code < ActiveRecord::Base


	def self.get
		code = self.where(:used => false).order(id: :asc).limit(1).first.lock(true)
		code.used = true
		code.save!
		return code.code
	end

	def self.last
		self.where(:used => true).order(id: :desc).limit(1).first
	end

end
