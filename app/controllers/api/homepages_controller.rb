require 'action_view'
require 'httparty'
require 'csv'
include ActionView::Helpers::NumberHelper

class Float
  def round_down n=0
  s = self.to_s
  l = s.index('.') + 1 + n
  s.length <= l ? self : s[0,l].to_f
  end
end

class Api::HomepagesController < ApplicationController

  caches_page :show

  def show

    crowdfunding_supporter = 2900 + 140 + 18  #startnext + untracked paypal + kto
    crowdfunding_amount = 3058.85 + 380.25 #untracked paypal + untracked kto
    startnext = 47630.52

    own_supporter = Support.where(:payment_completed => true).where.not(:payment_method => :crowdbar).count

    crowdbar_users = User.with_flag('hasCrowdbar',true).count + Flag.where(:name => 'crowdAppVisits').count

    supporter = crowdfunding_supporter + own_supporter + crowdbar_users

    own_funding_paypal_q = Support.where("payment_completed IS NOT NULL AND payment_method LIKE ?","paypal%",)

    own_funding_paypal = own_funding_paypal_q.sum(:amount_for_income)
    own_funding_paypal -= own_funding_paypal * 0.019
    own_funding_paypal -= own_funding_paypal_q.count * 0.19

    own_funding_query = Support.select('created_at,amount_for_income').where("payment_method = 'bank' AND payment_completed IS NOT NULL")
    own_funding = own_funding_query.sum(:amount_for_income)

    #Crowdcard
    #crowdcard = JSON.parse(File.read('public/crowdcard.json'))

    #temp
    crowdcard_total = 9008
    crowdcard_amount = crowdcard_total * 0.9

    # crowdcard_daily = JSON.parse(File.read('public/crowdcard_daily.json'))
    # crowdcard_sum = 0
    # for i in 1..7
    #   crowdcard_sum = crowdcard_sum + crowdcard_daily[i.day.ago.strftime('%Y-%m-%d')].to_f
    # end
    # crowdcard_average = crowdcard_sum / 7

    #if now - date(day before) < 24h
      #gelddiff / 24h * stunden
    #else
      #crowdbar_amount = crowdbar_yesterday

    #crowdbar
    cb_json = JSON.parse(File.read('public/crowdbar.json'))

    crowdbar_amount = cb_json["total_commission"] * 0.9

    total_amount = startnext + crowdfunding_amount + own_funding_paypal + own_funding + crowdbar_amount + crowdcard_amount

    donations = Support.where("payment_completed IS NOT NULL").sum(:amount_internal) + cb_json["total_commission"] * 0.1 + crowdcard_total * 0.1

    confirmed_users = User.where.not(:confirmed_at => nil).count

    #Prognose:
    #last_synced_day = Support.where(:payment_completed => true, :payment_method => 'crowdbar').order(created_at: :desc).limit(1).first
    prediction = {}
    #temp_q = Support.where(:created_at => (last_synced_day.created_at - 13.days).beginning_of_day..last_synced_day.created_at.end_of_day, :payment_method => :crowdbar)
    temp_q2 = Support.where(:created_at => (Time.now - 15.days).beginning_of_day..(Time.now - 2.days).end_of_day, :payment_completed => true).where.not(:payment_method => :crowdbar)
    prediction[:avg_daily_commission] = cb_json["seven_day_commission"] / 7 + temp_q2.sum(:amount_for_income) / 14
    prediction[:avg_daily_commission_crowdbar] = cb_json["seven_day_commission"] / 7
    prediction[:days] = ((12000 - (total_amount % 12000)) / prediction[:avg_daily_commission]).round
    prediction[:date] = Time.now + (prediction[:days].to_i).days
    number_of_participants = Chance.count()


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
      :crowdbar_users => number_with_precision(crowdbar_users, precision: 0, delimiter: '.'),
      :crowdbar_amount => crowdbar_amount,
      :crowdcard_amount => crowdcard_amount,
      #:crowdcard_today => number_with_precision(crowdcard_daily[Date.today.strftime('%Y-%m-%d')], precision: 2, delimiter: '.', separator: ','),
      :crowdcard_users => Crowdcard.sum(:number_of_cards),
      :squirrels => Payment.where(:active => true).count,
      :squirrel_monthly_amount => number_with_precision(Payment.where(:active => true).sum(:amount_total), precision: 0, delimiter: ''),
      :squirrel_monthly_amount_bge => number_with_precision(Payment.where(:active => true).sum(:amount_bge), precision: 0, delimiter: '.'),
      :squirrel_monthly_amount_society => number_with_precision(Payment.where(:active => true).sum(:amount_society), precision: 0, delimiter: '.'),
      :prediction => prediction,
      :number_of_participants => number_with_precision(number_of_participants, precision: 0, delimiter: '.'),
      :supports => Support.where(:comment => true, :payment_completed => false).order(:created_at => :desc).limit(12),
      :kpi_per_day => {
        :registered_confirmed_users_by_date => User.select('count(users.id) as anzahl, created_at, confirmed_at').where.not(:confirmed_at => nil).group_by{|x| x.created_at.strftime("%Y-%m-%d")} ,
        :donations_by_date => Support.select('payment_completed, created_at, sum(amount_internal) as summe').where("payment_completed IS NOT NULL").group_by{|x| x.created_at.strftime("%Y-%m-%d")} ,
        :basic_income_funding_by_month => own_funding_query.group_by{|x| x.created_at.strftime("%Y-%m-%d")} ,
      },
      :kpi => {
        :clv_donations => donations/confirmed_users,
        :clv_income => total_amount/confirmed_users,
        :crowdbar_users => number_with_precision(crowdbar_users, precision: 0, delimiter: '.')
      }


    }


    if params[:kpi]

      kpi_per_day = {
        :registered_confirmed_users_by_date => User.all.where.not(:confirmed_at => nil).group("DATE(created_at)").count,
        :donations_by_date => Support.all.where("payment_completed IS NOT NULL").group("DATE(created_at)").sum(:amount_internal) ,
        :basic_income_funding_by_date => Support.all.where("payment_completed IS NOT NULL").group("DATE(created_at)").sum(:amount_for_income) ,
        :kpi_social_groups_distribution => State.joins(:state_users).select('count(state_users.id)').group("states.text").order('count_state_users_id desc').count('state_users.id')
      }

      csv = CSV.generate() do |csv|
        columns = ['Date']
        columns << params[:kpi].to_s
        csv << columns
        kpi_per_day[params[:kpi].to_sym].each do |r|
          csv << r
        end
      end
      render text: csv
    else
      render json: homepage_data
    end

  end

end