class Api::UsersController < ApplicationController
#before_filter :authenticate_user!

  before_filter :load_user, only:[:show,:states, :wishes]


  def index
    expires_in 3.minutes, :public => true

    if current_user
      if params[:q]
        query = User.search do
          fulltext params[:q]
        end
        render json: query.results[0..20].map {|u|
          if u.id != current_user.id
            x = {
              name: u.name,
              id: u.id,
              avatar: u.avatar
            }
          end
          x
        }
      end
      if params[:rand]
        u = User.order("RANDOM()").first
        render json:
          {
            name: u.name,
            id: u.id,
            avatar: u.avatar
          }
      end
    end
  end

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
        me_too: (current_user && current_user.wishes.exists?(wish.id) ? true : false)
        #user: UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
      }
    end
    render json:x
  end


  def suggestions
    if current_user
      r = []

      iwishes = []

      initial_wishes = Suggestion.where(:email => current_user.email).first

      if initial_wishes
        initial_wishes.initial_wishes.split(';').each do |w|
          n = w
          n = n.strip
          n = n.gsub(/ich würde/i,'')
          n = n.gsub(/ich wuerde/i,'')
          if !n.empty? && n.length > 3 && n.length < 101
            iwishes << {
              original_wish: w,
              sanitized: n
            }
          end
        end
      end

      if !iwishes.empty?

        iwishes.each do |w|
          suggestion = {
            is_suggestion_for: w[:original_wish]
          }

          #CHECK FOR PERFECT MATCH

          wish = Wish.where(:text => w[:sanitized]).first
          wish = false if wish && !wish.users

          if wish

            if exists = UserWish.where(id:wish.user_wish_ids.sample).first
              sample_user = exists.user
            else
              sample_user = current_user
            end

            r << {
              suggestion: suggestion,
              id: wish.id,
              others_count: UserWish.where(wish_id:wish.id).count - 1,
              text: wish.text,
              wish_id: wish.id,
              wish_url: Rack::Utils.escape(wish.text),
              user: sample_user.slice(:name, :id, :avatar)
            }

          else

            query = Wish.search do
              fulltext w[:sanitized] do
                minimum_match 1
              end
            end

            query.results[0..2].each do |qr|
              wtemp = Wish.find(qr.id)
              if wtemp.users.count > 0
                wish = wtemp
                break
              end
            end

            if wish
              suggestion[:is_similar_only] = true
              r << {
                suggestion: suggestion,
                id: wish.id,
                others_count: UserWish.where(wish_id:wish.id).count - 1,
                text: wish.text,
                wish_id: wish.id,
                wish_url: Rack::Utils.escape(wish.text),
                user: UserWish.where(id:wish.user_wish_ids.sample).first.user.slice(:name, :id, :avatar)
              }
            else
              suggestion[:is_unique] = true
              r << {
                suggestion: suggestion,
                text: w[:sanitized],
                user: current_user.slice(:name, :id, :avatar)
              }
            end
          end



        end
      end



      user_ids = []
      current_user.user_wishes.each do |user_wish|
        user_ids << Wish.find(user_wish.wish_id).user_ids if user_wish.wish_id
      end

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

    if @user == current_user
      current_user.browser = "#{browser.name} #{browser.full_version}"
      current_user.os = browser.platform.to_s
      current_user.os += ", mobile" if browser.mobile?
      current_user.os += ", tablet" if browser.tablet?
      current_user.save
    end


    render json: @user, serializer: UserSerializer
  end

  def load_user
    @user = User.find(params[:id])
  end

end