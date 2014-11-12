class RegistrationsController < Devise::RegistrationsController
  require 'securerandom'

  respond_to :json

  def update

    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    #if has crowdbar -> save it
    if account_update_params[:has_crowdbar] == true && !current_user.chances.empty?
      Chance.where(:user_id => current_user.id).update_all(:crowdbar_verified => true)
    end


    #account updates
    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      render json: @user
    else
      render json: @user.errors, status: 403
    end

  end


  def create

    account_create_params = devise_parameter_sanitizer.sanitize(:sign_up)

    #account_create_params['sign_up_ip'] = request.remote_ip
    if cookies[:sign_ups]
      signups = cookies[:sign_ups].to_i + 1
    else
      signups = 1
    end
    cookies[:sign_ups] = signups
    #account_create_params['number_of_signups'] = signups

    super
  end

end