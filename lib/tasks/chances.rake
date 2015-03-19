require "rubygems"

namespace :chances do

  task :SetCodes => :environment do
    desc "set random codes for users"
    letters = ['1-12','13-24','25-36','37-48','49-60']
    i = 0
    (1..61).each do |c1|
      (1..61).each do |c2|
        letters.each do |c3|
          i = i + 1
          puts "#{i} - #{c1},#{c2},#{c3}"
          #13|25|13-24
          chance = Chance.where(:code => nil, :confirmed => true).sample
          if chance
            chance[:code] = "#{c1}|#{c2}|#{c3}"
            chance.save!
          end
        end
      end
    end
  end

  task :confirmSquirrels => :environment do
    desc "confirm chance of squirrels or set their chance"

    Payment.where(:active => true).each do |p|
      if !p.user_id.nil?
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


  # task :crowdjoker => :environment do
  #   desc "setup jokers for crowdcard users on location"


  #   cc_no = []
  #   cc_no << (11626..11999).to_a
  #   cc_no << (12626..12750).to_a

  #   cc_no.each do |blub|
  #     blub.each do |cc|
  #       puts "#{cc}"
  #       pw = Devise.friendly_token.first(8)
  #       user_data = {
  #         name: "Vor-Ort-Crowdcard Nr. #{cc}",
  #         email: "vorortcrowdcard#{cc}@mein-grundeinkommen.de",
  #         password: pw,
  #         password_confirmation: pw,
  #         datenschutz: true
  #       }
  #       user = User.new(user_data)
  #       user.skip_confirmation!
  #       if user.valid?
  #         if user.save!
  #           user.chances.create(:confirmed_publication => true, :first_name => "vorOrt", :last_name =>"nummer#{cc}", :dob => "1984-10-01", :code2 => "1")
  #         end
  #       end
  #     end
  #   end
  # end


end