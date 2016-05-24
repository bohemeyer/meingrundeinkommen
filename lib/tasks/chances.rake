require 'rubygems'

namespace :chances do
  task SetCodes: :environment do
    desc 'set random codes for users'

    # chances = Chance.where(:code => nil, :confirmed => true).shuffle
    #chances = Chance.where(confirmed: true).shuffle

    first_round = true  # false wenn alle generiert werden sollen, true wenn es einen startwert gibt (s.u.)

    i = 0

    wheel_numbers = (1..36)

    (1..13).each do |c1|
      wheel_numbers.each do |c2|
        wheel_numbers.each do |c3|
          wheel_numbers.each do |c4|
            if first_round && c1 == 5 && c2 == 11 && c3 == 17 && c4 == 25 #5•11•17•24
              first_round = false
            end
            next if first_round

            code = "#{c1}•#{c2}•#{c3}•#{c4}"

            code_save = {code: code, used: false}

            # if chances[i]
            #   # •
            #   code_save[:used] = true
            #   puts "#{i} - #{c1}•#{c2}•#{c3}•#{c4}"
            #   chances[i].update_attribute(:code, code)
            #   i += 1
            # end

            Code.create(code_save)

            # i = i + 1
          end
        end
      end
    end
  end

  task SetCodesForConfirmedButNoCode: :environment do
    desc 'set code for those chances that are confirmed but for some reason dont have a code yet'

    chances = Chance.where(code: nil, confirmed: true).order('random()')

    chances.each do |chance|
      chance.update_attribute(:code, Code.get)
    end
  end

  #### USE THIS ONE FOR INITIAL CODE GENERATION OF SQUIRRELS #####
  task SetRandomCodesForSquirrels: :environment do
    desc 'set code for squirrels'

    chances = Chance.where(code: nil, confirmed: true).order('random()')

    chances.each do |chance|
      chance.update_attribute(:code, Code.get_random)
    end
  end


  task SetCodesForTandems: :environment do
    desc 'set random codes for tandems'
    # set codes for tandems

    users_without_tandem = []
    allchances           = Chance.where('is_child = 0 and confirmed = 1 and code is not null')
    i                    = 0

    allchances.each do |chance|
      i      += 1
      uid     = chance.user.id
      tandems = Tandem.where("(inviter_id = #{uid} or invitee_id = #{uid}) and inviter_id in (select user_id from chances where confirmed=1) and invitee_id in (select user_id from chances where confirmed=1)  and inviter_id != invitee_id and inviter_id is not null and invitee_id is not null and disabled_by is null").limit(100)

      if tandems.any?

        puts "#{i} von #{allchances.count} | user: #{uid} - #{tandems.count} Tandems"

        if tandems.count < 7
          code = 1
          tandems.each do |t|
            role = t.inviter_id == uid ? 'inviter' : 'invitee'
            t.update_attribute("#{role}_code", code.to_s)
            code += 1
          end
        else
          i = 0
          (1..4).each do |c1|
            [2,3,4,6,7,9,10,11,12,13,15,16,17,19,20,22,23,24,25,27,28,29,30,32,33,34].each do |c2|
              next unless tandems[i]
              role = tandems[i].inviter_id == uid ? 'inviter' : 'invitee'
              tandems[i].update_attribute("#{role}_code", "#{c1}•#{c2}")
              i += 1
            end
          end
        end

      else
        users_without_tandem << uid
      end
    end
  end

  task setRandomTandems: :environment do
    desc 'set random tandems for ppl w/o tandem'

    q                    = 'is_child = 0 and confirmed = 1 and user_id not in (select inviter_id from tandems where inviter_id != invitee_id and inviter_id is not null and invitee_id is not null and disabled_by is null) and user_id not in (select invitee_id from tandems where inviter_id != invitee_id and inviter_id is not null and invitee_id is not null and disabled_by is null)'
    users_without_tandem = Chance.where(q).map(&:user_id)

    users = users_without_tandem.shuffle
    i     = 0
    while users[i]
      puts "#{i} of #{users_without_tandem.count}"
      Tandem.create(inviter_id: users[i],
                    invitee_id: users[i+1],
                    invitation_type: 'random',
                    invitee_participates: true,
                    inviter_code: '1',
                    invitee_code: '1')
      i += 2
    end
  end

  task confirmSquirrels: :environment do
    desc 'confirm chance of squirrels or set their chance'

    # test query: must be zero after script worked fine:
    # select count(id) from users where id not in (select user_id from chances where confirmed = 1) and id in (select user_id from payments where active = 1);

    Payment.where(active: true).each do |p|
      next unless !p.user_id.nil? && !p.user.nil? && p.user.winner == 0
      if !p.user.chances.any?
        # create chanche with fake dob
        chance = Chance.new(first_name: p.user_first_name,
                            user_id: p.user_id,
                            last_name: p.user_last_name,
                            dob: '1900-01-01',
                            is_child: false,
                            confirmed_publication: true,
                            remember_data: true,
                            confirmed: true)
        if chance.valid?
          chance.save!
        else
          puts "#{p.user_id} - #{chance.errors.first}"
        end
      else
        chances = p.user.chances
        chances.update_all(confirmed: true) unless chances.first.confirmed

      end
    end
  end

  task mailinvitees: :environment do
    desc 'send mail to mistakenly created invites'

    inv = Tandem.where("invitation_type='existing' and invitee_email is not null and invitee_email != '' and inviter_id = invitee_id and invitee_email not in (select email from users)")

    inv.each do |i|
      user = User.find_by_id(i[:inviter_id])
      next if user.nil?
      mailtext = "Hallo, \n\ndie Seite \"Mein Grundeinkommen\" will herausfinden, was mit Menschen passiert, wenn sie ein Bedingungsloses Grundeinkommen erhalten. Dazu verlosen sie regelmäßig an eine Person ein Grundeinkommen, das 1000 €  im Monat beträgt und ein Jahr lang ausgezahlt wird.\n\nFünfzehn Menschen erhalten das Geld schon.\nDieses Mal werden zwei Grundeinkommen an zwei Menschen verlost, die sich kennen.\nIch nehme selbst an der Verlosung teil und lade dich herzlich ein, mein_e Tandempartner_in zu sein. Du musst nichts weiter tun als diesem Link zu folgen und meine Tandem-Einladung zu aktivieren:\n\nhttps:\/\/www.mein-grundeinkommen.de\/tandem?mitdir=#{user.id} \n\nEs kostet nichts und im besten Fall erhalten wir beide ein Jahr lang Grundeinkommen.\n\nLiebe Grüße"
      subject  = 'Grundeinkommen für dich und mich'
      i.update_attributes(invitation_type: 'mail', invitee_email_subject: subject, invitee_email_text: mailtext, invitee_id: nil)
    end
  end

  task crowdjoker: :environment do
    desc 'setup jokers for crowdcard users on location'

    # cc_no = []
    # cc_no = (1..300).to_a
    # cc_no << (12626..12750).to_a

    # C160 bis C219

    (120..259).each do |cc|
      # blub.each do |cc|
      puts "C#{cc}"
      pw        = Devise.friendly_token.first(8)
      user_data = {
        name: "Vor-Ort-Crowdcard Nr. C#{cc}",
        email: "vorortcrowdcard#{cc}@mein-grundeinkommen.de",
        password: pw,
        password_confirmation: pw,
        datenschutz: true
      }
      user = User.new(user_data)
      user.skip_confirmation!
      next unless user.valid?
      if user.save!
        user.chances.create(confirmed_publication: true, first_name: 'vorOrt', last_name: "nummerC#{cc}", dob: '1984-10-01', confirmed: true)
      end
      # end
    end
  end
end
