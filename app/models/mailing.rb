class Mailing < ActiveRecord::Base

	def self.all_newsletter_receipients
		where( newsletter = true, confirmed_at != nil)
	end

end