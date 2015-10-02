class InvitationMailer < ActionMailer::Base
  default from: "Mein Grundeinkommen | Tandem-Verlosung<support@mein-grundeinkommen.de>"

  def invite_existing(tandem,inviter,invitee)
    @tandem = tandem
    @inviter = inviter
    @invitee = invitee
    mail(to: @invitee.email, subject: "#{@invitee.chances.first.first_name} will #bgeMitDir gewinnen")
  end

  def inform_about_link_confirmation(tandem,invitee,inviter)
    @tandem = tandem
    @inviter = inviter
    @invitee = invitee
    mail(to: @inviter.email, subject: "#{@invitee.chances.first.first_name} ist jetzt dein Tandem")
  end


end