require 'action_view'
include ActionView::Helpers::NumberHelper

class Float
  def round_down n=0
  s = self.to_s
  l = s.index('.') + 1 + n
  s.length <= l ? self : s[0,l].to_f
  end
end

class Api::HomepagesController < ApplicationController

  def show
  	#User.destroy_all

  	#cached_data = File.open("public/startnext.json") do |file|
    #  JSON.parse(file.read)
    #end
    #cached_amount = cached_data["project"]["funding_status"]

    #days_left = (Date.today - Date.parse(cached_data["project"]["end_date"])).to_i / 1.day
    #supporter = cached_data["project"]["supporters_count"]

    crowdfunding_supporter = 2901 + 58 + 10  #startnext + untracked paypal + kto
    crowdfunding_amount = 50630.52 + 1854.92 + 249.25 #startnext + untracked paypal + kto

    own_supporter = Support.count #where payment_completed

    supporter = crowdfunding_supporter + own_supporter

    own_funding_paypal_q = Support.where("payment_method LIKE ?","paypal%") #where payment_completed

    own_funding_paypal = own_funding_paypal_q.sum(:amount_for_income)
    own_funding_paypal -= own_funding_paypal * 0.019
    own_funding_paypal -= own_funding_paypal_q.count * 0.19

    # own_funding_paypal = own_funding_paypal / 1.19

    own_funding = Support.where(:payment_method => :bank).sum(:amount_for_income) #where payment_completed

    # own_funding = own_funding / 1.19

    #read crowdbar file
    crowdbar_day_before = 0#xx

    crowdbar_yesterday = 0#yy

    crowdbar_amount = Support.where(:payment_method => :crowdbar).sum(:amount_for_income)

    #if now - date(day before) < 24h
      #gelddiff / 24h * stunden
    #else
      #crowdbar_amount = crowdbar_yesterday

    total_amount = crowdfunding_amount + own_funding_paypal + own_funding + crowdbar_amount

    #Prognose:
    last_synced_day = Support.where(:payment_completed => true).order(created_at: :desc).limit(1).first
    prediction = {}
    temp_q = Support.where(:created_at => (last_synced_day.created_at - 9.days).beginning_of_day..last_synced_day.created_at.end_of_day, :payment_method => :crowdbar)
    prediction[:avg_daily_commission] = temp_q.sum(:amount_for_income) / 10
    prediction[:days] = ((12000 - (total_amount % 12000)) / prediction[:avg_daily_commission]).round
    prediction[:date] = Time.now + (prediction[:days].to_i).days





    amount_internal = Support.sum(:amount_internal)

    homepage_data = {
      :number_of_users => number_with_precision(User.count, precision: 0, delimiter: '.'),
      :number_of_wishes => number_with_precision(UserWish.count, precision: 0, delimiter: '.'),
      :number_of_wishes_raw => UserWish.count,
      :amount => number_with_precision(total_amount % 12000, precision: 0, separator: ',', delimiter: '.'),
      :totally_financed_incomes => (total_amount / 12000 - 0.5).round(0),
      :percentage => number_to_percentage((total_amount % 12000) / 120, precision: 0),
      :percentage_raw => (total_amount % 12000) / 120,
      #:days_left => days_left,
      :supporter => number_with_precision(supporter, precision: 0, delimiter: '.'),
      :amount_internal => amount_internal,
      :prediction => prediction
    }
    render json: homepage_data
  end

end