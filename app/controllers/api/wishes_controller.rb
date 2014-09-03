class Api::WishesController < ApplicationController

  include ConjugationHelper

  def create
    #current_user = User.first
    wish = Wish.where(text:params[:text]).first
    wish = Wish.create(params.permit(:text)) if !wish
    user_wish = current_user.user_wishes.where(wish:wish)
    user_wish = current_user.user_wishes.create wish:wish, story:params[:story] if user_wish.blank?

    # similar = Sunspot.more_like_this(wish) do
    #   fields :text
    # end

    #similar = wish.more_like_this.results[0].to_json

    x = {
      id: user_wish.id,
      #similar: similar.results[0..1],
      others_count: UserWish.where(wish_id:wish.id).count - 1,
      wish_id: wish.id,
      story: user_wish.story,
      text: wish.text,
      wish_url: Rack::Utils.escape(wish.text),
      wish: wish.conjugate,
      me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false)
    }

    render json: x
  end

  def users
    render json:Wish.find(params[:id]).users.order(:avatar => :desc)
  end

  def stories
    render json:Wish.find(params[:id]).user_wishes.where('story is not null and story != ""').order('created_at desc')
  end

  def states
    user_ids = Wish.find(params[:id]).user_ids
    r = State.select("states.id, states.text, count(states.id) as ccc").joins(:state_users).where('state_users.user_id'=>user_ids).group(:state_id).limit(25).order('ccc desc')
    render json:r
  end

  def wishes
    user_ids = Wish.find(params[:id]).user_ids
    r = []
    Wish.select("wishes.id, wishes.text, count(wishes.id) as ccc").joins(:user_wishes).where('user_wishes.user_id'=>user_ids).where.not('wishes.id' => params[:id]).group(:wish_id).limit(25).order('ccc desc').map do |wish|
      next if !wish
      r << {
        others_count: UserWish.where(wish_id:wish.id).count - 1,
        wish_id: wish.id,
        wish_url: Rack::Utils.escape(wish.text),
        wish: wish.conjugate,
        text: wish.text,
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false),
        user:UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
      }
    end
    render json:r
  end

  def show
    wish = Wish.find(params[:id])
    count = UserWish.where(wish_id:wish.id).count
    x = {
      count: count,
      others_count: count -1,
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

    page = params[:page] ? params[:page].to_i : 1

    limit = 8

    if params[:q]
      params[:q] = params[:q].gsub(/ich würde/i,'')
      limit = 5
      query = Wish.search do
        fulltext params[:q] do
          minimum_match 1
        end
      end

      if current_user
        base = base.where(wish_id:query.results.map(&:id)).where.not(wish_id: current_user.user_wishes.map(&:wish_id))
      else
        base = base.where(wish_id:query.results.map(&:id))
      end
    end

    x= []

    base.group(:wish_id).limit(limit).offset(limit*(page-1)).order('count_all desc').count.map do |id, count|
      next if !id
      wish = Wish.where(id:id).first
      next if !wish
      x << {
        others_count:count-1,
        count: count,
        wish_id: wish.id,
        wish_url: Rack::Utils.escape(wish.text),
        wish: wish.conjugate,
        text: wish.text,
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false),
        user:UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar),
        create: false
      }
    end

    if params[:q] && !Wish.where(text:params[:q]).first
      x << {
        text: params[:q],
        create: true
      }
    end

    render json:x
  end

end
