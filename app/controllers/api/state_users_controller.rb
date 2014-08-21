class Api::StateUsersController < ApplicationController

  def create
    #current_user = User.first
    state= State.find(params[:id])
    current_user.states << state if state && !current_user.states.exists?(state)
    head :ok
  end

  def index
    render json:UserWish.limit(100).order('created_at desc')
  end

  def destroy
    #current_user = User.first
    current_user.state_users.where(state_id:params[:id]).first.destroy
    render json:{}
  end



end
