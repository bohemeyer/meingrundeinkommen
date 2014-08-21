class Api::StatesController < ApplicationController

  def create
    #current_user = User.first
    state = State.where(text:params[:text]).first
    state = State.create(params.permit(:text)) if !state
    user_state = current_user.state_users.where(state:state)
    user_state = current_user.state_users.create state:state, story:params[:story] if user_state.blank?
    render json:user_state
  end

  def users
    render json:State.find(params[:id]).users
  end

  def stories
    render json:States.find(params[:id]).state_users.where('story is not null').order('created_at desc')
  end

  def index
    base = StateUser
    base = base.where(state_id:State.where('text like ?', "%#{params[:q]}%").pluck(:id)) if params[:q]
    x = base.group(:state_id).limit(5).order('count_all desc').count.map do |id,count|
      next if !id
      state = State.where(id:id).first
      {
        count:count,
        state:state.text,
        user:StateUser.where(id:state.state_user_ids.sample).first.user_id
      }
    end
    render json:x
  end


end
