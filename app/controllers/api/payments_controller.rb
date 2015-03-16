class Api::PaymentsController < ApplicationController

  def create
    payment = Payment.create(params[:payment].permit(:user_email, :user_first_name, :user_last_name, :user_street, :user_street_number, :amount_total, :amount_society, :amount_bge, :accept, :account_bank, :account_iban, :account_bic, :active))

    if current_user
      payment.user_email = current_user.email
      payment.user_id = current_user.id
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
      p.update_attributes(params[:payment].permit(:user_email, :user_first_name, :user_last_name, :user_street, :user_street_number, :amount_total, :amount_society, :amount_bge, :accept, :account_bank, :account_iban, :account_bic, :active))
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
