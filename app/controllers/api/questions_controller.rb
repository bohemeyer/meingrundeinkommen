class Api::QuestionsController < ApplicationController

  respond_to :json

  def create
    question = Question.where(text:params[:text]).first
    question = Question.create(:text => params[:text],:category => params[:category]) if !question
    render json: question if question.save
  end

  def destroy
    Question.find(params[:id]).destroy
    render json: true
  end

  def update
    q = Question.find(params[:id])
    if params[:up]
      q.update_attributes(:votes => q.votes + 1)
    end
    if current_user.admin?
      q.update_attributes(params.permit(:text,:category,:answer))
    end
    render json: q
  end

  def index
    if params[:q]
      query = Question.search do
        fulltext params[:q] do
            minimum_match 1
        end
      end
      render json: query.results
    else
      render json: Question.all.order(:votes => :desc)
    end
  end
end