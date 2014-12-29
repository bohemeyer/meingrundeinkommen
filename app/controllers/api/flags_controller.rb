class Api::FlagsController < ApplicationController

	def create
		if current_user && params[:name]
			format = Flag.flagformat(params[:value])
			if existing = current_user.flags.where(:name => params[:name]).first
				existing.update_attribute(format,params[:value])
				existing.update_attribute(:value_boolean, true)  if format != :value_boolean && params[:value]
				existing.update_attribute(:value_boolean, false) if format != :value_boolean && !params[:value]
			else
				existing = current_user.flags.create(:name => params[:name], format => params[:value])
				existing.update_attribute(:value_boolean, true)  if format != :value_boolean && params[:value]
				existing.update_attribute(:value_boolean, false) if format != :value_boolean && !params[:value]
			end
			render :json => {value: existing.display}
		end
	end

	def update
		if current_user && params[:name]
		  if params[:increment]
		  	old = current_user.flags.where(:name => params[:name]).first
		  	params[:value] = old ? old.value_integer + 1 : 1
		  	create()
		  end
		  # if params[:decrement]
		  # end
		  # if params[:toggle]
		  # end
		end
	end

	def index
		if current_user
		  flags = {}
	      current_user.flags.each do |flag|
	        flags[flag.name] = flag.display
	      end
	      render json: flags
	    end
	end


	def destroy
		if current_user && params[:name]
			current_user.flags.where(:name => params[:name]).destroy
			 render json: {:success => true}
		end
	end

end
