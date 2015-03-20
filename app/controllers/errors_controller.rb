class ErrorsController < ApplicationController

  def custom
  	render status: 500, template: "errors/custom", :layout => false
  end

end
