class Api::DrawingsController < ApplicationController
require 'json'

  def create
    #if current_user && current_user.id = 1
      characters = ['1','2','3','4','5','6','7','8','9','B','G','E']
      data = params[:d]

      data.each_with_index do |drawing,i|
        number = ""
        drawing[:digets].each do |d|
          number += "#{d[:value]}"
        end

        if Chance.where("code LIKE ?", "#{number}%").present?
          data[i][:niete] =  false
          if number.size == 4
            data[i][:user] = Chance.where(:code => number).first.user
          end
        else
          data[i][:niete] = true
        end

        data[i][:number] = number

        if number.size == 3
          data[i][:potentials] = []
          characters.each do |n|
            if Chance.where(:code => "#{number}#{n}".to_i).present?
              user = Chance.where(:code => "#{number}#{n}".to_i).first.user
            else
              user = :niete
            end
            data[i][:potentials] << user
          end
        else
          data[i][:potentials] = false
        end

      end

      File.open("public/drawings.json","w") do |f|
        f.write(data.to_json)
      end


      render json: data

    #end

  end

end
