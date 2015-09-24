class Api::StatisticsController < ApplicationController
  require 'csv'

  def index

    queries = {
      #:participantsConfirmed => "(user_id in (select user_id from flags where name like 'CrowdcardNumber') or user_id in (select user_id from flags where name like 'hasHadCrowdbar') or user_id in (select user_id from flags where name like 'crowdAppVisits'))",
      #:participantsConfirmedByCrowdcard => "user_id in (select user_id from flags where name like 'CrowdcardNumber')",
      #:participantsConfirmedByCrowdbar => "user_id in (select user_id from flags where name like 'hasHadCrowdbar')",
      #:participantsConfirmedByCrowdapp => "user_id in (select user_id from flags where name like 'crowdAppVisits')",
      #:participantsUnconfirmed =>  "user_id not in (select user_id from flags where name like 'CrowdcardNumber') and user_id not in (select user_id from flags where name like 'hasHadCrowdbar') and user_id not in (select user_id from flags where name like 'crowdAppVisits')",
      #:participantsUnconfirmedButOrderedCrowdcard => "user_id not in (select user_id from flags where name like 'CrowdcardNumber') and user_id not in (select user_id from flags where name like 'hasHadCrowdbar') and user_id not in (select user_id from flags where name like 'crowdAppVisits') and user_id in (select user_id from crowdcards)",
      #:participantsUnconfirmedButOrderedCrowdcardButNotYetSent => "user_id not in (select user_id from flags where name like 'CrowdcardNumber') and user_id not in (select user_id from flags where name like 'hasHadCrowdbar') and user_id not in (select user_id from flags where name like 'crowdAppVisits') and user_id in (select user_id from crowdcards where sent is null)"
    }

    queries_not = {
      #:notParticipating => "",
      #:notParticipatingButCrowdToolUser => " and (id in (select user_id from flags where name like 'CrowdcardNumber') or id in (select user_id from flags where name like 'hasHadCrowdbar') or id in (select user_id from flags where name like 'crowdAppVisits'))"
    }


    respond_to do |format|
      format.json {

        # newsletter_only = ''
        # base     = "select users.email, REPLACE(users.name,',','') from users, chances where users.id = chances.user_id #{newsletter_only} and is_child = 0 and "
        # base_not = "select users.email, REPLACE(users.name,',','') from users where users.id not in (select user_id from chances) #{newsletter_only} "

        stats = {}
        # queries.each do |key,query|
        #   stats[key] = ActiveRecord::Base.connection.execute("#{base} #{query}").count
        # end

        # queries_not.each do |key,query|
        #   stats[key] = ActiveRecord::Base.connection.execute("#{base_not} #{query}").count
        # end

        stats['crowdcardOrders'] = Crowdcard.all.count
        stats['crowdcardsOrdered'] = Crowdcard.sum(:number_of_cards)
        stats['participantsWithChildren'] = Chance.where(:confirmed => 1).count
        stats['participants'] = Chance.where(:is_child => 0, :confirmed => 1).count
        #stats['participants_mail_unconfirmed'] = 0
        #stats['participants_squirrel'] = 0
        #stats['participants_no_squirrel'] = 0
        #stats['not_participating'] = 0
        stats['Accounts'] = User.count
        stats['activeAccounts'] = User.where('confirmed_at is not null').count
        stats['newsletterSubscriptions'] = User.where('confirmed_at is not null and newsletter = 1').count
        #stats['newsletterRatio'] = (stats['newsletterSubscriptions'] / stats['activeAccounts']) * 100
        render json: stats
      }
      format.csv {
        if current_user && current_user.admin? && params[:stat]
          newsletter_only = " and confirmed_at is not null and newsletter = 1 "
          #base     = "select users.email, REPLACE(users.name,',','') from users, chances where users.id = chances.user_id #{newsletter_only} and is_child = 0 and "
          #base_not = "select users.email, REPLACE(users.name,',','') from users where id not in (select user_id from chances) #{newsletter_only} "

          b = "select email, REPLACE(name,',','') from users where confirmed_at is not null and newsletter = 1 "

          # if queries[params[:stat].to_sym]
          #   q = queries[params[:stat].to_sym]
          #   b = base
          # else
          #   if queries_not[params[:stat].to_sym]
          #     q = queries_not[params[:stat].to_sym]
          #     b = base_not
          #   else

          if params[:stat] == "participants"
            q = "and id in (select user_id from chances where confirmed = 1)"
          end

          if params[:stat] == "notParticipating"
            q = " and id not in (select user_id from chances where confirmed = 1)"
          end

          # if params[:stat] == "participantsSquirrel"
          #   q = " and id in (select user_id from chances where confirmed = 1) and id in (select user_id from payments)"
          # end

          # if params[:stat] == "participantsNoSquirrel"
          #   q = " and id in (select user_id from chances where confirmed = 1) and id not in (select user_id from payments)"
          # end

          # if params[:stat] == "participantsMailUnconfirmed"
          #   b = "select email, REPLACE(name,',','') from users where confirmed_at is null "
          #   q = "and id in (select user_id from chances where confirmed = 1)"
          # end




            # end
          # end


          r = CSV.generate() do |csv|
            ActiveRecord::Base.connection.execute("#{b} #{q}").each do |row|
              csv << row
            end
          end

          send_data r

        end
      }
    end


  end

end
