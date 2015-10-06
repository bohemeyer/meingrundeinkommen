class Tandem < ActiveRecord::Base

	validate :swopped

	def swopped
	  return false if self.invitee_id && self.inviter_id && Tandem.where(:inviter_id => self.invitee_id, :invitee_id =>self.inviter_id).count > 0
	end

end
