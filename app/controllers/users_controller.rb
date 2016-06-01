class UsersController < ApplicationController
  respond_to :json

  def index
    if params[:admin] && current_user && current_user.admin?
      render json: (User.search(params[:q]) + User.search(params[:q])).uniq
    end
  end

  def update
  	if params[:admin] && current_user && current_user.admin?
      @user = User.find(params[:id])
      @user.skip_confirmation! if params[:confirm_user]
      if params[:reset_pw]
        new_password = SecureRandom.hex(6)
        @user.password = @user.password_confirmation = new_password
      end
      if params[:enable_crowdbar]
        Flag.set(@user,{:name => 'hasCrowdbar', :value => true})
        Flag.set(@user,{:name => 'hasHadCrowdbar', :value => true})
      end
      @user.save
      render json: {user: @user, pw: new_password}
    end
  end

  def destroy
    if current_user && current_user.admin?
      User.find(params[:id]).destroy
      render :nothing => true, :status => 200
    end
  end

end