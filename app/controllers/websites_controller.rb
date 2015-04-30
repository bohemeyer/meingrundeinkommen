class WebsitesController < ApplicationController

  def show
  	Rails.cache.clear
  end

end