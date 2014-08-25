class RegistrationsController < Devise::RegistrationsController

  respond_to :json

  def update

    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      render json: @user
    else
      render json: @user.errors, status: 403
    end
  end

  def create
    params['user']['sign_up_ip'] = request.env['REMOTE_ADDR']
    if cookies[:sign_ups]
      signups = cookies[:sign_ups].to_i + 1
    else
      signups = 1
    end
    cookies[:sign_ups] = signups
    params['user']['number_of_signups'] = signups
    super
  end

end