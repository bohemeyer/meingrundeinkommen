require "rubygems"

namespace :chances do

  task :SetCodes => :environment do
    desc "set random codes for users"

    #chances = Chance.where(:code => nil, :confirmed => true).shuffle
    chances = Chance.where(:confirmed => true).shuffle
    #first_round = true
    i = 0
    [2,3,4,6,7,9,10,11,12,13,15,16,17,19,20,22,23,24,25,27,28,29,30,32].each do |c1|
      (1..24).each do |c2|
        (1..24).each do |c3|
          (1..6).each do |c4|
            if chances[i]
              # •
              puts "#{i} - #{c1}•#{c2}•#{c3}•#{c4}"
              chances[i].update_attribute(:code, "#{c1}•#{c2}•#{c3}•#{c4}")
            end
            i = i + 1
          end
        end
      end
    end


    #set codes for tandems

    users_without_tandem = []
    Chance.where('is_child = 0 and code is null') do |chance|
      uid = chance.user.id
      tandems = Tandem.where("(inviter_id = #{uid} or invitee_id = #{uid}) and inviter_id in (select user_id from chances where confirmed=1) and invitee_id in (select user_id from chances where confirmed=1)  and inviter_id != invitee_id and inviter_id is not null and invitee_id is not null and disabled_by is null").limit(100)

      if tandems.any?

        if tandems.count < 7
          code = 1
          tandems.each do |t|
            role = t.inviter_id == uid ? "inviter" : "invitee"
            t.update_attribute("#{role}_code", "#{code}")
            code = code + 1
          end
        else
          i = 0
          (1..24).each do |c1|
            (1..6).each do |c2|
              if tandems[i]
                role = t.inviter_id == uid ? "inviter" : "invitee"
                t.update_attribute("#{role}_code", "#{c1}•#{c2}")
                i = i + 1
              end
            end
          end
        end

      else
        users_without_tandem << uid
      end
    end

    #set codes for users without tandems

    users = users_without_tandem.shuffle
    i = 0
    while users[i] do
      Tandem.create({
        inviter_id: users[i],
        invitee_id: users[i+1],
        invitation_type: "random",
        invitee_participates: true,
        inviter_code: "1",
        invitee_code: "1"
      })
      i = i + 2
    end

  end

  task :confirmSquirrels => :environment do
    desc "confirm chance of squirrels or set their chance"

    #test query: must be zero after script worked fine:
    #select count(id) from users where id not in (select user_id from chances where confirmed = 1) and id in (select user_id from payments where active = 1);

    Payment.where(:active => true).each do |p|
      if !p.user_id.nil? && !p.user.nil?
        if !p.user.chances.any?
          #create chanche with fake dob
          chance = Chance.new({
            :first_name => p.user_first_name,
            :user_id => p.user_id,
            :last_name => p.user_last_name,
            :dob => '1900-01-01',
            :is_child => false,
            :confirmed_publication => true,
            :remember_data => true,
            :confirmed => true
          })
          if chance.valid?
            chance.save!
          else
            puts "#{p.user_id} - #{chance.errors.first.to_s}"
          end
        else
          chances = p.user.chances
          if !chances.first.confirmed
            chances.update_all(:confirmed => true)
          end

        end
      end
    end

  end


  task :mailinvitees => :environment do
    desc "send mail to mistakenly created invites"

    inv = Tandem.where("invitation_type='existing' and invitee_email is not null and invitee_email != '' and inviter_id = invitee_id and invitee_email not in (select email from users)")

    inv.each do |i|
      user = User.find_by_id(i[:inviter_id])
      unless user.nil?
        mailtext = "Hallo, \n\ndie Seite \"Mein Grundeinkommen\" will herausfinden, was mit Menschen passiert, wenn sie ein Bedingungsloses Grundeinkommen erhalten. Dazu verlosen sie regelmäßig an eine Person ein Grundeinkommen, das 1000 €  im Monat beträgt und ein Jahr lang ausgezahlt wird.\n\nFünfzehn Menschen erhalten das Geld schon.\nDieses Mal werden zwei Grundeinkommen an zwei Menschen verlost, die sich kennen.\nIch nehme selbst an der Verlosung teil und lade dich herzlich ein, mein_e Tandempartner_in zu sein. Du musst nichts weiter tun als diesem Link zu folgen und meine Tandem-Einladung zu bestätigen:\n\nhttps:\/\/www.mein-grundeinkommen.de\/tandem?mitdir=#{user.id} \n\nEs kostet nichts und im besten Fall erhalten wir beide ein Jahr lang Grundeinkommen.\n\nLiebe Grüße"
        subject = 'Grundeinkommen für dich und mich'
        i.update_attributes({:invitation_type => 'mail', :invitee_email_subject => subject, :invitee_email_text => mailtext, :invitee_id => nil})
      end
    end

  end


  task :crowdjoker => :environment do
    desc "setup jokers for crowdcard users on location"


    #cc_no = []
    #cc_no = (1..300).to_a
    #cc_no << (12626..12750).to_a

    (1..300).each do |cc|
      #blub.each do |cc|
        puts "#{cc}"
        pw = Devise.friendly_token.first(8)
        user_data = {
          name: "Vor-Ort-Crowdcard Nr. C#{cc}",
          email: "vorortcrowdcard#{cc}@mein-grundeinkommen.de",
          password: pw,
          password_confirmation: pw,
          datenschutz: true
        }
        user = User.new(user_data)
        user.skip_confirmation!
        if user.valid?
          if user.save!
            user.chances.create(:confirmed_publication => true, :first_name => "vorOrt", :last_name =>"nummerC#{cc}", :dob => "1984-10-01", :confirmed => true)
          end
        end
      #end
    end
  end


end