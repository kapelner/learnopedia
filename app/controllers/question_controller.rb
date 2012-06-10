class QuestionController < ApplicationController
  before_filter :authenticate_user!
  
  def add
    Question.create(params[:question].merge(:contributor_id => current_user))
    redirect_to :back
  end

  def delete
    q = Question.find(params[:id])
    q.destroy if q.contributor_id == current_user.id
    redirect_to :back
  end

  def search
    respond_to do |format|
      format.js { render }
    end
  end
end
