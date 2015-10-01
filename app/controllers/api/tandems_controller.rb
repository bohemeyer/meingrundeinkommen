class Api::TandemsController < ApplicationController


	def create

		tandem = params[:tandem].permit(:invitee_email, :invitee_name, :invitee_id, :inviter_id, :purpose, :invitation_type)
		tandem[:inviter_id] = current_user.id if tandem[:inviter_id].nil?
		tandem[:invitee_id] = current_user.id if tandem[:invitee_id].nil?
		if tandem[:invitation_type]
			if tandem[:invitation_type] == 'link'
				tandem[:invitation_accepted_at] = Time.now
				tandem[:invitee_participates] = true
				#send mail to inviter and inform about confirmation
				InvitationMailer.inform_about_link_confirmation(tandem,current_user,User.find(tandem[:invitee_id])).deliver
			else #existing, mail, random
				#check if email is already connected to existing user
				#send invitation mail
				if tandem[:invitation_type] == 'mail'
					InvitationMailer.invite_new(tandem,current_user,User.find(tandem[:invitee_id])).deliver
				else
					InvitationMailer.invite_existing(tandem,current_user,User.find(tandem[:invitee_id])).deliver
				end
			end

		end
		tandem[:invitation_token] = loop do
		  token = SecureRandom.urlsafe_base64
		  break token unless Tandem.exists?(invitation_token: token)
		end

    	render json: {:tandem =>  Tandem.create(tandem)}

	end

	def update
		if params[:confirm]
			tandem = Tandem.find(params[:id])
			if tandem.invitation_token == params[:confirm]
				#set confirmed
				tandem[:invitation_accepted_at] = Time.now
				tandem.save
				#send email to inviter and inform about confirmation
				InvitationMailer.inform_mail_confirmation(tandem,current_user,User.find(tandem[:inviter_id])).deliver
				render json: {:success => true}
			end
		end


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
