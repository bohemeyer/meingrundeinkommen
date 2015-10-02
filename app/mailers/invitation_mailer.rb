class InvitationMailer < ActionMailer::Base
  default from: "support@mein-grundeinkommen.de"

  def invite_existing(tandem,inviter,invitee)
    @tandem = tandem
    @inviter = inviter
    @invitee = invitee
    mail(to: @invitee.email, subject: "#{@invitee.chances.first.first_name} will #bgeMitDir gewinnen")
  end
end