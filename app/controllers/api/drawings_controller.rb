class Api::DrawingsController < ApplicationController
require 'json'

  def create
    if current_user && current_user.id = 1
      #characters = ['1','2','3','4','5','6','A','B']
      data = params[:d]



      data.each_with_index do |drawing,i|
        number = ""

        digits = []



        drawing[:digets].each_with_index do |d,i|
          digits << d[:value] if d[:value] && d[:value] != ""
        end



        # if digits.count == 3
        #   t = '1-12'  if digits[2] <= 12
        #   t = '13-24' if digits[2] >= 13 && digits[2] <= 24
        #   t = '25-36' if digits[2] >= 25 && digits[2] <= 36
        #   t = '37-48' if digits[2] >= 37 && digits[2] <= 48
        #   t = '49-60' if digits[2] >= 49 && digits[2] <= 60
        #   digits[2] = t
        # end

#       letters = ['[1-12]','[13-24]','[25-36]','[37-48]','[49-60]']

        number = digits.join(",")



        if Chance.where("code LIKE ?", "#{number}%").present?
          data[i][:niete] = false
          if digits.count == 6
            data[i][:user] = Chance.where("code = ?", "#{number}").first.user
            data[i][:isChild] = Chance.where("code = ?", "#{number}").first.is_child
            data[i][:childName] = Chance.where("code = ?", "#{number}").first.first_name
          else
            data[i][:user] = false
          end
        else
          data[i][:niete] = true
          data[i][:user] = false
        end



        data[i][:number] = number

        # if number.size == 4
        #   data[i][:potentials] = {}
        #   characters.each do |n|
        #     if Chance.where(:code => "#{number}#{n}").present?
        #       user = Chance.where(:code => "#{number}#{n}").first.user
        #     else
        #       if Chance.where(:code2 => "#{number}#{n}").present?
        #         user = Chance.where(:code2 => "#{number}#{n}").first.user
        #       else
        #         user = :niete
        #       end
        #     end
        #     data[i][:potentials]["#{n}"] = user
        #   end
        # else
        #   data[i][:potentials] = false
        # end

      end



      File.open("public/currentdrawing.json","w") do |f|
        f.write(data.to_json)
      end


      render json: data

    end

  end

end
