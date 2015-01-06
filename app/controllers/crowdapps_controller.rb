class CrowdappsController < ApplicationController

	def show
	  if params[:installed]
		Flag.increment(current_user,{name: 'crowdAppVisits'}) if current_user
	  	redirect_to 'http://bar.mein-grundeinkommen.de/shops'
	  else
	  	if params[:installed_for]
			Flag.increment(current_user,{name: 'crowdAppVisits'}) if current_user
			Flag.increment(User.find(params[:installed_for]),{name: 'crowdAppVisits'}) if !current_user
			redirect_to 'http://bar.mein-grundeinkommen.de/shops'
		else
		  	redirect_to '/crowdbar'
		end
	  end
	end

end