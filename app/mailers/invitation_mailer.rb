class InvitationMailer < ActionMailer::Base
  default from: "support@mein-grundeinkommen.de"

  def invite_existing(tandem,inviter)
    @tandem = tandem
    @inviter = inviter
    mail(to: @tandem.invitee_email, subject: 'LALALALALA')
  end
end