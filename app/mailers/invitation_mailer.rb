class InvitationMailer < ActionMailer::Base
  default from: "Mein Grundeinkommen | Tandem-Verlosung<support@mein-grundeinkommen.de>"

  def invite_existing(tandem,inviter,invitee)
    @tandem = tandem
    @inviter = inviter
    @invitee = invitee
    mail(to: @invitee.email, subject: "#{@inviter.chances.first.first_name} will #bgeMitDir gewinnen")
  end

  def inform_about_link_confirmation(tandem,invitee,inviter)
    @tandem = tandem
    @inviter = inviter
    @invitee = invitee
    mail(to: @inviter.email, subject: "#{@invitee.chances.first.first_name} ist jetzt dein Tandem")
  end

  def invite_new(tandem,inviter)
    @tandem = tandem
    @inviter = inviter
    @invitee_name = invitee.name if invitee.name
    mail(from: "#{inviter.chances.first.first_name} #{inviter.chances.first.last_name} via Mein Grundeinkommen<support@mein-grundeinkommen.de>", reply_to: @inviter.email, to: @tandem.invitee_email, subject: @tandem.invitee_email_subject)

  end

end