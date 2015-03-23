class Api::SupportsController < ApplicationController

  #caches_page :index


  def create
    support = Support.create(params.permit(:amount_total, :amount_for_income, :amount_internal, :payment_method, :recurring))

    if current_user
      support.nickname = current_user.name
      support.email = current_user.email
    end

    if support.valid?
      support.save!
      render json: support
    else
      render json: {:errors => support.errors}
    end
  end

  def update
    s = Support.find(params[:id])
    if current_user && current_user.admin? and params[:admin]
      s.update_attributes(:payment_completed => params[:payment_completed])
    else
      s.update_attributes(:comment => params[:comment], :nickname => params[:nickname])
    end
    render json: s
  end

  def index
    if current_user && current_user.admin? and params[:admin]
     render json: Support.where('payment_method = "bank" or payment_method like "paypal%"').order(:id => :desc)
    else
      if params[:crowdbar]
       render json: Support.where("comment is not null and payment_method = 'crowdbar'").limit(20)
      else
        render json: Support.where('comment is not null and payment_completed is not null').limit(30).order(:updated_at => :desc)
      end
    end
  end

  def show
    render json: Support.find(params[:id])
  end


end
