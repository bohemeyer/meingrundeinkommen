class Api::NotificationsController < ApplicationController

  def index
	render json: Notification.last
	#noch nicht abgelaufen
	#noch nicht gelesen
	#noch nicht gepusht if crowdbarr = true
  end

end
