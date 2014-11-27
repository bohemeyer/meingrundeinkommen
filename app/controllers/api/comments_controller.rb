class Api::CommentsController < ApplicationController

	def create
		render json: Comment.create(:text => params[:text], :user_id => current_user.id, :commentable_type => 'blogpost', :commentable_id => params[:post_id]) if current_user
	end

	def index
		render json: Comment.where(:commentable_type => 'blogpost', :commentable_id => params[:post_id]).order('created_at desc')
	end

end
