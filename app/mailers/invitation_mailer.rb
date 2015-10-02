class InvitationMailer < ActionMailer::Base
  default from: "support@mein-grundeinkommen.de"

  def invite_existing(tandem,inviter,invitee)
    @tandem = tandem
    @inviter = inviter
    @invitee = invitee
    mail(to: @tandem.invitee_email, subject: "#{@invitee.chances.first_name} will #bgeMitDir gewinnen")
  end
end