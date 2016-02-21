class Api::ChancesController < ApplicationController

  def create
    if Setting.get('raffleOpen')
      chance = current_user.chances.create(params.permit(:first_name, :last_name, :dob, :is_child, :country_id, :city, :confirmed_publication, :remember_data, :confirmed, :mediacoverage, :phone, :affiliate))
      chance.confirmed = true
      chance.code = Code.get
      if chance.valid?
        chance.save!
        render json: {:chance => chance}
      else
        render json: {:errors => chance.errors}
      end
    end
  end

  def update
    if Setting.get('raffleOpen')
      chance = current_user.chances.find(params[:id])
      params[:confirmed] = true
      params[:code] = Code.get unless chance.confirmed
      if chance.update_attributes(params.permit(:first_name, :last_name, :dob, :city, :confirmed_publication, :remember_data, :crowdcard_code, :confirmed, :mediacoverage, :phone, :affiliate, :code))
        render json: {:chance => chance}
      else
        render json: {:errors => chance.errors, :chance => chance}
      end
    end
  end

  def destroy
    #if !current_user.winner
      current_user.chances.where(id:params[:id]).first.destroy
      render json: {:success => true}
    #end
  end

end
