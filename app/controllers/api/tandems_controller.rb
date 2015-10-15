class Api::TandemsController < ApplicationController


	def index
		x = []
		Tandem.where("invitee_id != inviter_id and inviter_id is not null and invitee_id is not null and ((invitee_grudges_inviter_for is not null and invitee_grudges_inviter_for != '') or (inviter_grudges_invitee_for is not null and inviter_grudges_invitee_for !='')").sample(50).map do |tandem|
	      inviter = User.find_by_id(tandem.inviter_id).first
	      invitee = User.find_by_id(tandem.invitee_id).first

	      next if inviter.nil? || invitee.nil? || (!inviter.nil? && inviter.avatar.nil?) || (!invitee.nil? && invitee.avatar.nil?)

	      grudges = []

	      if !tandem.invitee_grudges_inviter_for.nil? && !tandem.invitee_grudges_inviter_for == ""
	      	grudges << {
		      	grudge: tandem.invitee_grudges_inviter_for
		      	grudger: inviter
		      	grudgee: invitee
		    }
		  end

		  if !tandem.inviter_grudges_invitee_for.nil? && !tandem.inviter_grudges_invitee_for == ""
	      	grudges << {
		      	grudge: tandem.inviter_grudges_invitee_for
		      	grudger: invitee
		      	grudgee: inviter
		    }
		  end

		  grudge = grudges.sample

	      x << {
	        grudger: {
	        	avatar: grudge.grudger.avatar
	        	id: grudge.grudger.id
	        	name: grudge.grudger.name
	        },
	        grudgee: {
	        	avatar: grudge.grudgee.avatar
	        	id: grudge.grudgee.id
	        	name: grudge.grudgee.name
	        }
	        grudge: grudge.grudge
	      }
		end
		render json: x
    end

		tandems.

	end

	def create

		#todo:

		grudge = params[:grudge]
		tandem = params[:tandem].permit(:invitee_email, :invitee_name, :invitee_id, :inviter_id, :purpose, :invitation_type, :invitee_email_subject, :invitee_email_text)

		r = false

		if tandem[:invitation_type] && (tandem[:invitee_id] == current_user.id || tandem[:inviter_id] == current_user.id) && current_user.tandems.count < 100

			tandem[:invitee_grudges_inviter_for] = grudge if tandem[:invitee_id] == current_user.id
			tandem[:inviter_grudges_invitee_for] = grudge if tandem[:inviter_id] == current_user.id

			tandem[:invitation_token] = loop do
			  token = SecureRandom.urlsafe_base64
			  break token unless Tandem.exists?(invitation_token: token)
			end

			#check if invited email address already exists in users and change to existing tandem
			if tandem[:invitation_type] == 'mail'
				partner = User.where(:email => tandem[:invitee_email]).first
				if partner
					tandem[:invitation_type] == 'existing'
					tandem[:invitee_id] == partner.id
				end
			end


			if tandem[:invitation_type] == 'link'
				tandem[:invitation_accepted_at] = Time.now
				tandem[:invitee_participates] = true
				#send mail to inviter and inform about confirmation
				if r = Tandem.create(tandem)
					InvitationMailer.inform_about_link_confirmation(tandem,current_user,User.find(tandem[:inviter_id])).deliver
				end
			else #existing, mail, random
				tandem[:invitation_accepted_at] = Time.now
				if tandem[:invitation_type] == 'existing'
					if r = Tandem.create(tandem)
						InvitationMailer.invite_existing(tandem,current_user,User.find(tandem[:invitee_id])).deliver
					end
				else
					r = Tandem.create(tandem)
				end
			end

		end

    	render json: {:tandem => r }

	end

	def update
			tandem = Tandem.find(params[:id])
			tandem[:invitee_grudges_inviter_for] = params[:grudge] if tandem[:invitee_id] == current_user.id
			tandem[:inviter_grudges_invitee_for] = params[:grudge] if tandem[:inviter_id] == current_user.id
			tandem.save
			#InvitationMailer.inform_mail_confirmation(tandem,current_user,User.find(tandem[:inviter_id])).deliver
			render json: {:success => true}
	end

	def destroy

		tandem = Tandem.find(params[:id])
		if tandem.inviter_id == current_user.id || tandem.invitee_id == current_user.id
			tandem.disabled_by = current_user.id
			tandem.save
			render json: {:success => true}
		end
	end

end
