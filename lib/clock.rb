require 'clockwork'
require '../config/boot'
require '../config/environment'
require 'httparty'
require 'csv'

module Clockwork

  configure do |config|
    config[:logger] = Logger.new("../log/clock.log")
  end

  handler do |job|

    if job == "cache.news"

      #response = HTTParty.get('http://blog.meinbge.de/wp-json/posts?filter[posts_per_page]=500')
      response = HTTParty.get('http://blog.meinbge.de/wp-json/wp/v2/posts?filter[posts_per_page]=500')
      json = JSON.parse(response.body)

      File.open("../public/news.json", "w+") do |f|
        f.write(json.to_json)
      end

    end


    if job == "crowdbar.stats"

      response = HTTParty.get('http://bar.mein-grundeinkommen.de/crowd_bar_stats.json')
      json = JSON.parse(response.body)

      File.open("../public/crowdbar.json", "w+") do |f|
        f.write(json.to_json)
      end

    end


    if job == "clear.cache"
      cache_dir = ActionController::Base.page_cache_directory
      FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
    end

    if job == "bank.check"
      results = `/home/hibiscus/scripts/enter_umsatz.pl`
      puts results
    end

    if job == "newsletter.send"
      path_to_file = '../tmp/mailqueue.json'

      if File.exist?(path_to_file)
        params = JSON.parse(File.read(path_to_file))
        File.delete(path_to_file)

        users = MailingsMailer.prepare_recipients(params["groups"],params["group_keys"])
        puts users.count
        puts MailingsMailer.transactionmail(users,params["subject"],params["body"]).deliver
      end
    end



  end

  every(5.minutes, 'newsletter.send')
  every(3.minutes, 'cache.news')
  every(3.minutes, 'crowdbar.stats')
  every(10.minutes, 'clear.cache')
  every(20.minutes, 'bank.check')
end