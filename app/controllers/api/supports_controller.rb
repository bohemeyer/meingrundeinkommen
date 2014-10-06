class Api::SupportsController < ApplicationController

  def create
    support = Support.create(params.permit(:amount_total, :amount_for_income, :amount_internal, :payment_method, :recurring))

    if current_user
      support.nickname = current_user.name
      support.email = current_user.email
    end

    if support.valid?
      support.save!
      render json: {:support => support}
    else
      render json: {:errors => support.errors}
    end
  end

  def index
    #where anonymous == false and comment true
  end

  def update
    #Support.find(params[:id]).update_attributes()
  end

end
