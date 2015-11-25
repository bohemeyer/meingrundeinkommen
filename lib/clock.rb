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

      response = HTTParty.get('http://blog.meinbge.de/wp-json/wp/v2/posts?filter[posts_per_page]=500')
      json = JSON.parse(response.body)
      posts = []
      puts json.length
      json.each do |opost|
        post = opost
        thumb = JSON.parse(HTTParty.get("http://blog.meinbge.de/wp-json/wp/v2/media/#{opost['featured_image']}").body)
        if thumb['media_details']
          post['thumb'] = thumb['media_details']['sizes']['post-thumbnail']['source_url'] if thumb['media_details']['sizes']['post-thumbnail']
          post['image'] = thumb['media_details']['sizes']['large']['source_url']          if thumb['media_details']['sizes']['large']
        end
        author = JSON.parse(HTTParty.get("http://blog.meinbge.de/wp-json/wp/v2/users/#{opost['author']}").body)
        post['authorname'] = author['name'] if author['name']
        posts << post

      end

      File.open("../public/news.json", "w+") do |f|
        f.write(posts.to_json)
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

        users.each_slice(10).to_a.each do |user_group|
          puts MailingsMailer.transactionmail(user_group,params["subject"],params["body"]).deliver
        end
      end
    end

    if job == "invitations.send"
        invitations = Tandem.where(:invitee_email_sent => nil, :invitation_type => 'mail')
        invitations.each do |i|
          user = User.find_by_id(i[:inviter_id])
          unless user.nil?
            puts InvitationMailer.invite_new(i,user).deliver
            i.update_attribute(:invitee_email_sent,Time.now)
          end
        end

    end

    # if job == "tandem.statusupdate"
    #     sql = "update tandems set invitee_participates=1 where invitation_type='existing' and inviter_id != invitee_id and inviter_id is not null and invitee_id is not null and invitee_id in (select user_id from chances where confirmed=1);"
    #     ActiveRecord::Base.connection.execute(sql)
    # end



  end

  every(3.minutes, 'cache.news')
  every(5.minutes, 'invitations.send')
  every(5.minutes, 'newsletter.send')
  every(3.minutes, 'crowdbar.stats')
  every(10.minutes, 'clear.cache')
  every(20.minutes, 'bank.check')
  #every(25.minutes, 'tandem.statusupdate')

end