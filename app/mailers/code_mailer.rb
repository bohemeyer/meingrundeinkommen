class CodeMailer < ActionMailer::Base
  default from: "Mein Grundeinkommen | Verlosung<support@mein-grundeinkommen.de>"

  def send_code(user)
    @user = user
    @code = user.chances.map(&:code).join('; ')
    mail(to: @user.email, subject: "Deine Losnummer")
  end

end