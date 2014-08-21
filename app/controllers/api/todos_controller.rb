class Api::TodosController < ApplicationController

  def index
    render json: Todo.all
  end

  def show
    todo = Todo.find params[:id]
    render json: todo
  end

  def create
    todo = Todo.new(post_params)
    todo.save
    render json: todo, status: 201
  end

  def destroy
    todo = Todo.find params[:id]
    todo.destroy
    render nothing: true, status: 201
  end

  private
    def post_params
      params.require(:todo).permit(:title)
    end

end