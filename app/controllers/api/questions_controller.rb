class Api::QuestionsController < ApplicationController

  respond_to :json

  def create
    question = Question.where(text:params[:text]).first
    question = Question.create(params.permit(:text,:category)) if !question
    render json: question if question.save
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
      render json: Question.all
    end
  end
end