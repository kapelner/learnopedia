class AnswerController < ApplicationController

  def index
    @q = Question.find(params[:id])
  end
  
  def add

  end

  def edit

  end

  def delete

  end
  
end
