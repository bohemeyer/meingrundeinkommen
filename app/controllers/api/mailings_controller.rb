class Api::MailingsController < ApplicationController
  #require 'mailers/massmailer'

  def create

  	if current_user.admin?
	  	possible_user_groups = %w(byids# last_squirrel_id# frst_notification_not_sent is_squirrel sign_up_after# without_crowdbar with_crowdbar has_code participating confirmed with_newsletter)

	  	if params[:groups]
		  	groups = []

		  	users = User
		  	params[:groups].each_with_index do |g,i|
		  	  if possible_user_groups.include? g
		  	  	if params[:group_keys][i].empty?
		  	  		users = users.send(g)
		  	  	else
		  	  		params[:group_keys][i] = params[:group_keys][i].split(',') if g == "find#"
					users = users.send(g.sub!('#',''),params[:group_keys][i])
				end
		  	  end
		  	end

		    # users = User.send(groups.join('.'))
		end



		if params[:send]
			users = [User.find(current_user.id)] if params[:test]
			test = MailingsMailer.transactionmail(users,params[:subject],params[:body]).deliver
			render json: test
		else
			render json: { count: users ? users.count : 0, groups: possible_user_groups }
		end
	end
  end
end