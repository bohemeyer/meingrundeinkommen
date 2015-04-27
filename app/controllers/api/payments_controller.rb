class Api::PaymentsController < ApplicationController

  def create
    if current_user && current_user.payment.nil?
      payment = Payment.create(params[:payment].permit(:user_email, :user_first_name, :user_last_name, :user_street, :user_street_number, :amount_total, :amount_society, :amount_bge, :accept, :account_bank, :account_iban, :account_bic, :active))
      payment.user_email = current_user.email
      payment.user_id = current_user.id

      if payment.valid?
        payment.save!
        render json: payment
      else
        render json: {:errors => payment.errors}
      end
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

      if params[:q]
        query = Payment.search do
          fulltext params[:q] do
            minimum_match 1
          end
        end
        r = query.results
      else
        r = Payment.all
      end

      render json: r
    end
  end

  def destroy
    p = Payment.find(params[:id])
    if current_user && (current_user == p.user || current_user.admin?)
      p.destroy
      render json: false
    end
  end


end
