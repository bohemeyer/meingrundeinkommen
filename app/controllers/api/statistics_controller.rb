class Api::StatisticsController < ApplicationController

  def index

    queries = {
      :participantsConfirmed => "(user_id in (select user_id from flags where name like 'CrowdcardNumber') or user_id in (select user_id from flags where name like 'hasHadCrowdbar') or user_id in (select user_id from flags where name like 'crowdAppVisits'))",
      :participantsConfirmedByCrowdcard => "user_id in (select user_id from flags where name like 'CrowdcardNumber')",
      :participantsConfirmedByCrowdbar => "user_id in (select user_id from flags where name like 'hasHadCrowdbar')",
      :participantsConfirmedByCrowdapp => "user_id in (select user_id from flags where name like 'crowdAppVisits')",
      :participantsUnconfirmed =>  "user_id not in (select user_id from flags where name like 'CrowdcardNumber') and user_id not in (select user_id from flags where name like 'hasHadCrowdbar') and user_id not in (select user_id from flags where name like 'crowdAppVisits')",
      :participantsUnconfirmedButOrderedCrowdcard => "user_id not in (select user_id from flags where name like 'CrowdcardNumber') and user_id not in (select user_id from flags where name like 'hasHadCrowdbar') and user_id not in (select user_id from flags where name like 'crowdAppVisits') and user_id in (select user_id from crowdcards)",
      :participantsUnconfirmedButOrderedCrowdcardButNotYetSent => "user_id not in (select user_id from flags where name like 'CrowdcardNumber') and user_id not in (select user_id from flags where name like 'hasHadCrowdbar') and user_id not in (select user_id from flags where name like 'crowdAppVisits') and user_id in (select user_id from crowdcards where sent is null)"
    }


    respond_to do |format|
      format.json {

        newsletter_only = ''
        base = "select users.email, REPLACE(users.name,',','') from users, chances where users.id = chances.user_id #{newsletter_only} and is_child = null and "

        stats = {}
        queries.each do |key,query|
          stats[key] = ActiveRecord::Base.connection.execute("#{base} #{query}").count
        end

        stats['crowdcardOrders'] = Crowdcard.all.count
        stats['crowdcardsOrdered'] = Crowdcard.sum(:number_of_cards)
        stats['participantsWithChildren'] = Chance.all.count
        stats['participants'] = Chance.where(:is_child => nil).count

        render json: stats
      }
      format.csv {
        if current_user && current_user.admin? && params[:stat]
          newsletter_only = " and confirmed_at is not null and newsletter = 1 "
          base = "select users.email, REPLACE(users.name,',','') from users, chances where users.id = chances.user_id #{newsletter_only} and is_child = null and "
          debugger
          send_data ActiveRecord::Base.connection.execute("#{base} #{queries[params[:stat].to_sym]}").to_csv
        end
      }
    end


  end

end
