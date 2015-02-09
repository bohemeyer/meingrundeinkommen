require 'clockwork'
require '../config/boot'
require '../config/environment'
require 'httparty'
require 'csv'

module Clockwork

  handler do |job|


    if job == "check.crowdbar.stats"

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

    end


    if job == "cache.news"

      response = HTTParty.get('http://blog.meinbge.de/wp-json/posts')
      json = JSON.parse(response.body)

      File.open("../public/news.json", "w+") do |f|
        f.write(json.to_json)
      end

    end


    if job == "check.crowdcard.stats"

      #sum
      response = HTTParty.get('http://grundeinkommen.hundertfeuer.de/paybackStatsExtended.json')
      json = JSON.parse(response.body)
      File.open("../public/crowdcard.json", "w+") do |f|
        f.write(json.to_json)
      end

      #daily
      daily = {}
      response = HTTParty.get('http://grundeinkommen.hundertfeuer.de/paybackStats.json')
      json = JSON.parse(response.body)

      json["dates"].each do |d|
        points = 0
        d["entries"].each do |e|
          points = points + (e["points"].to_f / 100) unless e["action"] == "Punkte ausgezahlt"
        end
        daily[d["date"]] = points
      end


      File.open("../public/crowdcard_daily.json", "w+") do |f|
        f.write(daily.to_json)
      end

    end



  end

  #every(1.hours, 'check.crowdbar.stats')
  #every(30.seconds, 'cache.news')
  every(1.minutes, 'check.crowdcard.stats')

end