
class LanguagesController < ApplicationController

  require 'json'

  ##
  # get the german language file
  def de
    file = File.read(Rails.root.join('client', 'languages', 'deDe.json'))
    data_hash = JSON.parse(file)
    render :json => data_hash
  end

end