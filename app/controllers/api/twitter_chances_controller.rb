class Api::TwitterChancesController < ApplicationController

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def create
    chance = Chance.new({
      :first_name => 'twitter_user',
      :user_id => nil,
      :last_name => params[:username],
      :dob => '1900-01-01',
      :is_child => false,
      :confirmed_publication => true,
      :remember_data => true,
      :confirmed => true
    })
    if chance.save
      render json: {:success => true}
    else
      render json: {:errors => 'already participating'}
    end
  end

end
