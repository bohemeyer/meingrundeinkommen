class Api::CrowdcardsController < ApplicationController

  def create
    crowdcard = current_user.crowdcards.create(params.permit(:first_name, :last_name, :street, :house_number, :city, :zip_code, :country))
    if crowdcard.valid?
      crowdcard.save!
      render json: {:crowdcard => crowdcard}
    else
      render json: {:errors => crowdcard.errors}
    end
  end

end
