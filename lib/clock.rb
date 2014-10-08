require 'clockwork'
require '../config/boot'
require '../config/environment'
require 'httparty'
require 'csv'

module Clockwork

  handler do |job|

    sales = HTTParty.get('http://www.crowdbar.org/stats/233146-referals-by-day.csv').body
    commissions = HTTParty.get('http://www.crowdbar.org/stats/248432-daily-commission-as-table.csv').body
    last_syn_file = HTTParty.get('http://www.crowdbar.org/stats/253222-last-affiliate-sync.csv').body

    if sales

      sync_times = []
      CSV.parse(last_syn_file, :headers => true).each do |sync|
        sync_times << sync[1]
      end
      sync_times.sort
      latest_sync_date = sync_times.last.to_time - 1.day

      CSV.parse(sales, :headers => true).each do |day|
        date = day[0]
        puts date
        sales = day[1].to_i
        commission = 0
        CSV.parse(commissions, :headers => true).each do |commission_day|
          commission = commission_day[1].to_f
          break if commission_day[0] == date
        end

        average_amount = (commission / sales).round(2)

        new_data = { :payment_method => 'crowdbar', :amount_total => average_amount, :amount_for_income => (average_amount * 0.9).round(2), :amount_internal => (average_amount - (average_amount * 0.9)).round(2) , :payment_completed => latest_sync_date.strftime('%Y-%m-%d') < date ? false : true , :created_at => "#{date} 00:00:00" }
        old = Support.where("payment_method = ? AND DATE(created_at) = ?", 'crowdbar', date)

        if old.count > sales
          Support.delete(old.limit(old.count - sales).map(&:id))
          old.update_all(new_data)
        end

        if old.count < sales
          new_n = sales - old.count
          n = 0
          while n < new_n do
            Support.create(new_data)
            n +=1
          end
          old.update_all(new_data)
        end

      end


    end

    # response = HTTParty.get('https://www.startnext.de/tycon/modules/crowdfunding/api/v1.1/projects/15645/?client_id=82142814552425')
    # json = JSON.parse(response.body)
    # current_amount = json["project"]["funding_status"]
    # if File.exists?("../public/startnext.json")
    #   cached_data = File.open("../public/startnext.json") do |file|
    #     JSON.parse(file.read)
    #   end
    #   cached_amount = cached_data["project"]["funding_status"]
    # end
    # if (defined?(cached_amount) && cached_amount != current_amount) || !defined?(cached_amount)
    #   File.open("../public/startnext.json", "w+") do |f|
    #     f.write(json.to_json)
    #   end
    # end

  end

  every(1.hours, 'check crowdbar stats')

end