class ConfirmationsController < Devise::ConfirmationsController

  respond_to :json

  private

  def after_confirmation_path_for(resource_name, resource)
  	"/login?email=#{resource.email}&confirmed=true"
  end

end