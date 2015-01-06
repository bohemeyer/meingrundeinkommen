class Api::FlagsController < ApplicationController

	def create
		if current_user && params[:name]
			flag = Flag.set(current_user,params)
			render :json => {value: flag.display}
		end
	end

	def update
		if current_user && params[:name]
		  if params[:increment]
		  	flag = Flag.increment(current_user,params)
		  	render :json => {value: flag.display}
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
