require "rubygems"

namespace :chances do

  task :SetCodes => :environment do
    desc "set random codes for users"

    first_chars = ['1','2']
    chars = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U']
    i = 0
    chars.each do |c1|
      chars.each do |c2|
        chars.each do |c3|
          first_chars.each do |c4|
            i = i + 1
            puts "#{i} - #{c1}#{c2}#{c3}#{c4}"

            chance = Chance.where(:code => nil, :code2 => 1).sample
            if chance
              chance[:code] = "#{c1}#{c2}#{c3}#{c4}"
              chance.save!
            end

          end
        end
      end
    end

  end


  task :crowdjoker => :environment do
    desc "setup jokers for crowdcard users on location"


    cc_no = []
    cc_no << (11626..11999).to_a
    cc_no << (12626..12750).to_a

    cc_no.each do |blub|
      blub.each do |cc|
        puts "#{cc}"
        pw = Devise.friendly_token.first(8)
        user_data = {
          name: "Vor-Ort-Crowdcard Nr. #{cc}",
          email: "vorortcrowdcard#{cc}@mein-grundeinkommen.de",
          password: pw,
          password_confirmation: pw,
          datenschutz: true
        }
        user = User.new(user_data)
        user.skip_confirmation!
        if user.valid?
          if user.save!
            user.chances.create(:confirmed_publication => true, :first_name => "vorOrt", :last_name =>"nummer#{cc}", :dob => "1984-10-01", :code2 => "1")
          end
        end
      end
    end
  end


end