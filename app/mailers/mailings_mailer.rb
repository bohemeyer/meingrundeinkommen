class MailingsMailer < MassMandrill::MandrillMailer

  def transactionmail(recipients,subject,content,template = 'transactionmail')
    addresses = recipients.map { |recipient| recipient.email }
    #global_merge_vars = [{ name: 'headline', content: 'This is first example notice' }]
    merge_vars = recipients.map do |recipient|
      {
        :rcpt => recipient.email,
        :vars => [
                    { :name => 'name', :content => recipient.name }
                 ]
      }
    end

    template_content = [{ :name => 'body', :content => content }]

    mail(to: addresses,
         from: 'Mein Grundeinkommen <support@mein-grundeinkommen.de>',
         subject: subject,
         template_content: template_content,
         template: template,
         #global_merge_vars: global_merge_vars,
         merge_vars: merge_vars)

  end

end