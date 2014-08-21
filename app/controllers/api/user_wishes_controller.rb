class Api::UserWishesController < ApplicationController

  def create
    #current_user = User.first
    wish = Wish.find(params[:wish_id])
    if wish && !current_user.wishes.exists?(wish)
      current_user.wishes << wish
      render json: {:me_too => true}
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
