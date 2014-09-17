class Api::DrawingsController < ApplicationController
require 'json'

  def create

    data = params[:d]

    data.each_with_index do |drawing,i|
      number = ""
      drawing[:digets].each do |d|
        number += "#{d[:value]}"
      end

      data[i][:niete] =  User.where(:id => number.to_i).present? ? false : true
      data[i][:number] = number

      if number.size == 4
        data[i][:potentials] = []
        [0..9].each do |n|
          if User.where(:id => "#{number}#{n}".to_i).present?
            user = User.where(:id => "#{number}#{n}".to_i).first
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

  end

end
