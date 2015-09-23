class Api::WinnersController < ApplicationController

  caches_page :index
  #everyone's a winner baby, that's for sure! :)

  def index
    render json: User.where('winner > 0').order('winner asc')
  end

end