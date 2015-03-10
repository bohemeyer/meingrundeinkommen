class Api::PaymentsController < ApplicationController

  def create
    payment = Payment.create(params.permit(:amount_total, :amount_for_income, :amount_internal, :bank_account, :bank_owner, :bank_code, :email))

    if current_user
      payment.email = current_user.email
    end

    if payment.valid?
      payment.save!
      render json: payment
    else
      render json: {:errors => payment.errors}
    end
  end

  def update
    p = Payment.find(params[:id])
    if current_user && ((current_user.admin? and params[:admin]) || (p.user && current_user == p.user))
      p.update_attributes(:active => params[:active])
    end
    render json: p
  end

  def index
    if current_user && current_user.admin? and params[:admin]
      render json: Payment.all
    end
  end

  def destroy
    p = Payment.find(params[:id])
    if current_user && current_user == p.user
      p.destroy
    end
  end


end
