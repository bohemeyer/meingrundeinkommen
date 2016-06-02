class Api::WinnersController < ApplicationController

  caches_page :index
  #everyone's a winner baby, that's for sure! :)

  def index
    expires_in 1.minutes, :public => true

  	winners = User.select('id,name,avatar').where('winner > 0').order('winner asc')
    render json: winners, serializer: nil
  end

end