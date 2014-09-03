class Api::UsersController < ApplicationController
#before_filter :authenticate_user!

  before_filter :load_user, only:[:show,:states, :wishes]

  def states
    if current_user && @user == current_user
      render json: @user.state_users
    else
      render json: @user.state_users.where(:visibility => true)
    end
    #render json: @user.states.includes(:state_users)
  end

  def wishes
    #render json: @user.user_wishes.includes(:wish)

    x = []

    @user.user_wishes.order('created_at desc').map do |user_wish|
      next if !user_wish
      wish = Wish.where(id:user_wish.wish_id).first
      next if !wish
      x << {
        id: user_wish.id,
        others_count: UserWish.where(wish_id:wish.id).count - 1,
        text: wish.text,
        wish_id: wish.id,
        wish_url: Rack::Utils.escape(wish.text),
        wish: wish.conjugate,
        story: user_wish.story,
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false),
        user: UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
      }
    end
    render json:x
  end


  def suggestions
    if current_user
      user_ids = []
      current_user.user_wishes.each do |user_wish|
        user_ids << Wish.find(user_wish.wish_id).user_ids if user_wish.wish_id
      end
      r = []
      Wish.select("wishes.id, wishes.text, count(wishes.id) as ccc").where.not(id: current_user.user_wishes.map(&:wish_id)).joins(:user_wishes).where('user_wishes.user_id'=>user_ids).group(:wish_id).limit(25).order('ccc desc').map do |wish|
        next if !wish
        r << {
          id: wish.id,
          others_count: UserWish.where(wish_id:wish.id).count - 1,
          text: wish.text,
          wish_id: wish.id,
          wish_url: Rack::Utils.escape(wish.text),
          user: UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
        }
      end
      render json:r
    end
  end


  def show
    render json: @user
  end

  def load_user
    @user = User.find(params[:id])
  end

end