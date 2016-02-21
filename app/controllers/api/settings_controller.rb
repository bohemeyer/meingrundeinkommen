class Api::SettingsController < ApplicationController

  def index
    r= {}
    Setting.all.each do |s|
    	r[s.name] = s.value
    end
    render json: r
  end

end
