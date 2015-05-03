class MailingsMailer < MassMandrill::MandrillMailer
  include ActionView::Helpers::NumberHelper

  def possible_user_groups
    %w(confirmed with_newsletter sign_up_after# participating has_code without_crowdbar with_crowdbar is_squirrel frst_notification_not_sent last_squirrel_id# byids#)
  end

  def prepare_recipients(groups,group_keys)

    users = User
    groups.each_with_index do |g,i|
      g2 = "#{g}#"
      if self.possible_user_groups.include?(g) || self.possible_user_groups.include?(g2)
        if group_keys[i].empty?
            users = users.send(g)
        else
            users = users.send(g.sub('#',''),group_keys[i])
        end
      end
    end
    return users
  end


  def transactionmail(recipients,subject,content,template = 'transactionmail')
    addresses = recipients.map { |recipient| recipient.email }
    #global_merge_vars = [{ name: 'headline', content: 'This is first example notice' }]
    merge_vars = recipients.map do |recipient|
      {
        :rcpt => recipient.email,
        :vars => [
                    { :name => 'name', :content => recipient.name },
                    { :name => 'uid', :content => recipient.id },
                    # { :name => 'losnummern', :content => receipient.chances.any? ? receipient.chances.code.join("; ") : '' },
                    { :name => 'ch_betrag', :content => !recipient.payment.blank? ? number_with_precision(recipient.payment.amount_total, precision: 2, separator: ',', delimiter: '.') : '' },
                    { :name => 'ch_id', :content => !recipient.payment.blank? ? recipient.payment.id : '' },
                    { :name => 'real_first_name', :content => recipient.chances.any? ? !recipient.chances.where(:is_child => false).empty? ? recipient.chances.where(:is_child => false).first.first_name : '' : '' }
                 ]
      }
    end

    template_content = [{ :name => 'body', :content => content }]

    mail(to: addresses,
         from: 'Mein Grundeinkommen <micha@meinbge.de>',
         subject: subject,
         template_content: template_content,
         template: template,
         #global_merge_vars: global_merge_vars,
         merge_vars: merge_vars,
         message_extra: {
           track_opens: true,
           headers: {
               "Reply-To" => 'Mein Grundeinkommen <support@mein-grundeinkommen.de>'
             }
         }
         )

  end

end