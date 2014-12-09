class Api::CrowdbarsController < ApplicationController

	def show

	  sign_out() if current_user && params[:logout]

	  @user = current_user ? current_user : false
	  @shop_id = params[:shop_id] || false
      render "crowdbar/v0.1/crowdbar", :layout => false

	end

end