class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  #before_filter :set_cache_buster

  before_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery? && current_user.present?
  end

  # def set_cache_buster
  #   response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
  #   response.headers["Pragma"] = "no-cache"
  #   response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  # end

  layout :layout_by_resource

 protected

  def layout_by_resource
    if devise_controller?
      "no_angular"
    else
      "application"
    end
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password,
      :password_confirmation, :remember_me, :avatar, :initial_wishes, :initial_conditions, :avatar_cache, :sign_up_ip, :number_of_signups, :newsletter, :datenschutz, :veganz) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :has_crowdbar, :crowdbar_not_found, :password,
      :password_confirmation, :current_password, :avatar, :avatar_cache, :newsletter) }
  end
end


