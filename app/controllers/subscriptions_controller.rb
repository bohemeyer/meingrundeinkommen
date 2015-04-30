class SubscriptionsController < ApplicationController

  def show
  	u = User.find(params[:id])
  	if u.email = params[:email]
  		u.update_attribute(:newsletter,false)
  	end

  	render :text => "Die Adresse #{params[:email]} wurde vom Newsletter abgemeldet. Neu-Anmeldung ist jederzeit auf deinem Profil möglich."

  end
end