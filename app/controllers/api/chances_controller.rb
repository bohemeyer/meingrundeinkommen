class Api::ChancesController < ApplicationController

  def create
    chance = current_user.chances.create(params.permit(:full_name, :dob, :is_child, :country_id, :city, :confirmed_publication))
    if chance.valid?
      chance.save!
      render json: {:chance => chance}
    else
      render json: {:errors => chance.errors}
    end
  end

  def destroy
    current_user.chances.where(id:params[:id]).first.destroy
    render json: {:success => true}
  end

end
