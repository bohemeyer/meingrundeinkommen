class Api::UserWishesController < ApplicationController
  include ActionView::Helpers::DateHelper

  def create
    #current_user = User.first
    wish = Wish.find(params[:wish_id])
    if wish && !current_user.wishes.exists?(wish)
      current_user.wishes << wish
      user_wish = current_user.user_wishes.last

    if params[:remove_initial_wish]
      User.find(current_user.id).update_attributes(initial_wishes: current_user.initial_wishes.sub!(params[:remove_initial_wish], ''))
    end


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
      params[:id] =  current_user.user_wishes.where(:wish_id => params[:wish_id])
      destroy
    end
  end

  def index

    x = []
    UserWish.limit(10).order('updated_at desc').map do |user_wish|
      wish = Wish.where(id:user_wish.wish_id).first
      next if !wish
      x << {
        id: user_wish.id,
        others_count: UserWish.where(wish_id: user_wish.wish_id).count,
        wish_id: user_wish.wish_id,
        wish_url: Rack::Utils.escape(wish.text),
        wish: wish.conjugate,
        story: user_wish.story,
        text: wish.text,
        time_ago: time_ago_in_words(user_wish.created_at),
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false),
        user: user_wish.user.slice(:name, :id, :avatar)
      }
    end

    render json: x

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
