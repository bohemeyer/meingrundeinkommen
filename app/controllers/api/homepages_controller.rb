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

  	cached_data = File.open("public/startnext.json") do |file|
      JSON.parse(file.read)
    end
    cached_amount = cached_data["project"]["funding_status"]
    #days_left = (Date.today - Date.parse(cached_data["project"]["end_date"])).to_i / 1.day
    supporter = cached_data["project"]["supporters_count"]

    homepage_data = {
      :number_of_users => number_with_precision(User.count, precision: 0, delimiter: '.'),
      :number_of_wishes => number_with_precision(UserWish.count, precision: 0, delimiter: '.'),
      :number_of_wishes_raw => UserWish.count,
      :amount => number_with_precision(cached_amount % 12000, precision: 0, separator: ',', delimiter: '.'),
      :totally_financed_incomes => (cached_amount / 12000).round(0),
      :percentage => number_to_percentage((cached_amount % 12000) / 120, precision: 0),
      :percentage_raw => (cached_amount % 12000) / 120,
      #:days_left => days_left,
      :supporter => number_with_precision(supporter, precision: 0, delimiter: '.')
    }
    render json: homepage_data
  end

end