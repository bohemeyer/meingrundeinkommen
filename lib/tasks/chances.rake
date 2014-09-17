require "rubygems"

namespace :chances do


  task :SetCodes => :environment do
    desc "set random codes for users"

    chars = ['B','G','E','1','2','3','4','5','6','7','8','9']
    i = 0
    chars.each do |c1|
      chars.each do |c2|
        chars.each do |c3|
          chars.each do |c4|
            i = i + 1
            puts "#{i} - #{c1}#{c2}#{c3}#{c4}"
            chance = Chance.where(:code => nil).sample
            if chance
              chance.code = "#{c1}#{c2}#{c3}#{c4}"
              chance.save!
            end
          end
        end
      end
    end



  end

end