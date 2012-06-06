class ConceptVideoController < ApplicationController
  def add
    redirect_to :action => :index, :id => params[:concept_bundle][:page_id]
  end
end