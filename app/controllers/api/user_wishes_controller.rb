class Api::UserWishesController < ApplicationController

  def create
    #current_user = User.first
    wish = Wish.find(params[:wish_id])
    if wish && !current_user.wishes.exists?(wish)
      current_user.wishes << wish
      user_wish = current_user.user_wishes.last

      x = {
        id: user_wish.id,
        others_count: UserWish.where(wish_id:wish.id).count - 1,
        wish_id: wish.id,
        story: user_wish.story,
        text: wish.text,
        wish_url: Rack::Utils.escape(wish.text),
        wish: wish.conjugate,
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false)
      }

      render json: x


    else
      params[:id] = params[:wish_id]
      destroy
    end
  end

  def index
    render json:UserWish.limit(100).order('created_at desc')
  end

  def update
    #current_user = User.first
    current_user.user_wishes.where(id:params[:id]).first.update_attributes(story: params[:story])
    render json: {:success => true}
  end

  def destroy
    #current_user = User.first
    current_user.user_wishes.where(id:params[:id]).first.destroy
    render json: {:me_too => false}
  end



end
