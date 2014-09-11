class Api::StateUsersController < ApplicationController

  def create
    state= State.find(params[:id])
    current_user.states << state if state && !current_user.states.exists?(state)
    head :ok
  end

  def destroy
    current_user.state_users.where(id:params[:id]).first.destroy
    render json:{}
  end

  def update
    current_user.state_users.where(id:params[:id]).first.update_attributes(visibility: params[:visibility])
    render json: {:success => true}
  end



end
