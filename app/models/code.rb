class Code < ActiveRecord::Base


	def self.get
		code = self.where(:used => false).order(id: :asc).first
		code.with_lock do
			code.used = true
			code.save!
		end
		return code.code
	end

	def self.last
		self.where(:used => true).order(id: :desc).limit(1).first
	end

end
