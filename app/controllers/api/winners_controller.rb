class Api::WinnersController < ApplicationController

  caches_page :index
  #everyone's a winner baby, that's for sure! :)

  def index
  	winners = User.select('id,name,avatar').where('winner > 0').order('winner asc')
    render json: winners
  end

end