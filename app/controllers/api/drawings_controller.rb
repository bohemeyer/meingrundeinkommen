class Api::DrawingsController < ApplicationController
require 'json'

  def create
    if current_user && current_user.id = 1
      #characters = ['1','2','3','4','5','6','A','B']
      data = params[:d]

      winner = false

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

        number = digits[0..3].join("•") # •

        drawing[:tandemcode] = digits[4..-1].join("•") if digits[4]

        query = Chance.where("code LIKE ?", "#{number}%")

        if query.present?
          data[i][:niete] = false
          if query.count == 1
            winner = query.first
            if winner.user
              data[i][:user] = winner.user
            # else
            #   data[i][:user] = { :name => "Twitter-Nutzer @#{winner.last_name}", :id => 0 }
            # end

              data[i][:isChild] = winner.is_child
              data[i][:childName] = winner.first_name
            end
            else
              data[i][:user] = false
            end
        else
          data[i][:niete] = true
          data[i][:user] = false
        end

        data[i][:number] = number


        if winner
          tandem = Tandem.where("(inviter_code = '#{drawing[:tandemcode]}' and inviter_id = #{winner.user.id}) or (invitee_code = '#{drawing[:tandemcode]}' and invitee_id = #{winner.user.id})").first

          if tandem.present?
             partner_id = tandem.inviter_id if tandem.invitee_id == winner.user.id
             partner_id = tandem.invitee_id if tandem.inviter_id == winner.user.id
             data[i][:tandem] = User.find_by_id(partner_id)
          else
            data[i][:tandem] = false
          end
        end


      end



      File.open("public/currentdrawing.json","w") do |f|
        f.write(data.to_json)
      end


      render json: data

    end

  end

end
