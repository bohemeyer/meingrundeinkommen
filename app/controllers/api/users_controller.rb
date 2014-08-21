class Api::UsersController < ApplicationController
#before_filter :authenticate_user!

  before_filter :load_user, only:[:show,:states, :wishes]

  def states
    render json: @user.states.includes(:state_users)
  end

  def wishes
    #render json: @user.user_wishes.includes(:wish)

    x = @user.user_wishes.order('created_at desc').map do |user_wish|
      next if !user_wish
      wish = Wish.where(id:user_wish.wish_id).first
      {
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

  def show
    render json: @user
  end

  def load_user
    @user = User.find(params[:id])
  end

end