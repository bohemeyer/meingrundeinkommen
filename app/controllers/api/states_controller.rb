class Api::StatesController < ApplicationController

  def create
    #current_user = User.first
    state = State.where(text:params[:text]).first
    state = State.create(params.permit(:text)) if !state
    user_state = current_user.state_users.where(state:state)
    user_state = current_user.state_users.create state:state, visibility:params[:visibility] if user_state.blank?
    render json:user_state
  end

  def users
    render json:State.find(params[:id]).users
  end

  def stories
    render json:States.find(params[:id]).state_users.where('story is not null').order('created_at desc')
  end

  def index

    query = State.search do
      fulltext params[:q]
    end


    if current_user
      r = []
      query.results.each do |result|
        r << result.text if !current_user.state_users.map(&:state_id).include?(result.id)
      end
    else
      r = query.results.map(&:text)
    end

    render json: r
  end


end
