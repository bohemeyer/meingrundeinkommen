class PreviewsController < ApplicationController

  respond_to :html

  def show
  	render :file => "layouts/preview"
  end

end