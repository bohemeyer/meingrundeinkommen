class Api::CrowdcardsController < ApplicationController

  def create
    crowdcard = Crowdcard.create(params.permit(:first_name, :last_name, :street, :house_number, :city, :zip_code, :country, :number_of_cards)) if !current_user
    crowdcard = current_user.crowdcards.create(params.permit(:first_name, :last_name, :street, :house_number, :city, :zip_code, :country, :number_of_cards)) if current_user
    if crowdcard.valid?
      crowdcard.save!
      render json: {:crowdcard => crowdcard}
    else
      render json: {:errors => crowdcard.errors}
    end
  end

  def update
  	if current_user && current_user.admin? and params[:admin]
  	  c = Crowdcard.find(params[:id])
	  c.update_attributes(:sent => Date.today)
      render json: c
    end
  end

  def index
  	if current_user && current_user.admin? and params[:admin]

      cc = Crowdcard.all
      cc_unsent = Crowdcard.where(:sent => nil)

  	  respond_to do |format|
	    format.json { render json: cc_unsent.order(:id => :asc) }
	    format.csv { send_data params[:show_all] ? cc.to_csv : cc_unsent.to_csv }
	    #format.xls # { send_data @products.to_csv(col_sep: "\t") }
	  end


    end
  end

end
