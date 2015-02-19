class Api::DrawingsController < ApplicationController
require 'json'

  def create
    if current_user && current_user.id = 1
      characters = ['1','2','3','4','5','6','A','B']
      data = params[:d]

      data.each_with_index do |drawing,i|
        number = ""
        drawing[:digets].each do |d|
          number += "#{d[:value]}"
        end

        if Chance.where("code LIKE ? or code2 LIKE ?", "#{number}%", "#{number}%").present?
          data[i][:niete] =  false
          if number.size == 5
            data[i][:user] = Chance.where("code = ? or code2 = ?", "#{number}", "#{number}").first.user
            data[i][:isChild] = Chance.where("code = ? or code2 = ?", "#{number}", "#{number}").first.is_child
            data[i][:childName] = Chance.where("code = ? or code2 = ?", "#{number}", "#{number}").first_name

          end
        else
          data[i][:niete] = true
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
