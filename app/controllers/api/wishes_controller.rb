class Api::WishesController < ApplicationController

  include ConjugationHelper

  def create
    #current_user = User.first
    wish = Wish.where(text:params[:text]).first
    #wish = Wish.find(:first, :conditions => ["lower(text) = ?", params[:text]])
    wish = Wish.create(params.permit(:text)) if !wish
    user_wish = current_user.user_wishes.where(wish:wish)
    user_wish = current_user.user_wishes.create wish:wish, story:params[:story] if user_wish.blank?
    render json: {user_wish: user_wish, wish: wish}
  end

  def users
    render json:Wish.find(params[:id]).users
  end

  def stories
    render json:Wish.find(params[:id]).user_wishes.where('story is not null').order('created_at desc')
  end

  def states
    user_ids = Wish.find(params[:id]).user_ids
    r = State.select("states.id, states.text, count(states.id) as ccc").joins(:state_users).where('state_users.user_id'=>user_ids).group(:state_id).limit(25).order('ccc desc')
    render json:r
  end

  def wishes
    user_ids = Wish.find(params[:id]).user_ids
    r = Wish.select("wishes.id, wishes.text, count(wishes.id) as ccc").joins(:user_wishes).where('user_wishes.user_id'=>user_ids).group(:wish_id).limit(25).order('ccc desc')
    render json:r
  end

  def show
    wish = Wish.find(params[:id])
    x = {
      others_count: UserWish.where(id:wish.id).count - 1,
      wish_id: wish.id,
      id: wish.id,
      text: wish.text,
      wish_url: Rack::Utils.escape(wish.text),
      wish: wish.conjugate,
      me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false),
      user:UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
    }
    render json: x
  end

  def index

    base = UserWish

    base = base.where(wish_id:Wish.where('text like ?', "%#{params[:q]}%").pluck(:id)) if params[:q]

    x = base.group(:wish_id).limit(25).order('count_all desc').count.map do |id,count|
      next if !id
      wish = Wish.where(id:id).first
      {
        others_count:count - 1,
        wish_id: wish.id,
        wish_url: Rack::Utils.escape(wish.text),
        wish: wish.conjugate,
        text: wish.text,
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false),
        user:UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
      }
    end
    render json:x
  end

end
