class Api::SettingsController < ApplicationController

  def index
    expires_in 1.minutes, :public => true

    r= {}
    Setting.all.each do |s|
    	r[s.name] = s.value
    end
    render json: r
  end

end
