class QuestionController < ApplicationController
  before_filter :authenticate_user!
  
  def add
    cb = ConceptBundle.find(params[:concept_bundle_id])
    cb.questions << Question.create(params[:question].merge(:contributor_id => current_user))
    redirect_to :back
  end

  def edit
    q = Question.find(params[:id])
    q.update_attributes(params[:question])
    render :nothing => true
  end

  def delete
    cb = ConceptBundle.find(params[:cbid])
    q = Question.find(params[:qid])
    cb.questions.delete(q) if q.contributor_id == current_user.id
    redirect_to :back
  end

  def search
    respond_to do |format|
      format.js { render }
    end
  end
end
