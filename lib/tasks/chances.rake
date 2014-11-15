require "rubygems"

namespace :chances do


  task :SetCodes => :environment do
    desc "set random codes for users"

    first_chars = ['1','2','3','4','5','6']
    chars = ['A','B','1','2','3','4','5','6']
    i = 0
    first_chars.each do |c1|
      chars.each do |c2|
        chars.each do |c3|
          chars.each do |c4|
            chars.each do |c5|
              i = i + 1
              puts "#{i} - #{c1}#{c2}#{c3}#{c4}#{c5}"

              code_type = []
              code_type << :code  if Chance.where(:code  => nil).count > 0
              code_type << :code2 if Chance.where(:code2 => nil, :crowdbar_verified => true).count > 0

              unless code_type.empty?
                code_type = code_type.sample
                chance = Chance.where(:code => nil).sample if code_type == :code
                chance = Chance.where(:code2 => nil, :crowdbar_verified => true).sample if code_type == :code2
                if chance
                  chance[code_type] = "#{c1}#{c2}#{c3}#{c4}#{c5}"
                  chance.save!
                end
              end
            end
          end
        end
      end
    end



  end

end