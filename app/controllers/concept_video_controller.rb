class ConceptVideoController < ApplicationController
  def add
    ConceptVideo.create({
      :video => params[:concept_video][:video],
      :concept_bundle_id => params[:concept_video][:cb_id]
    })
    redirect_to :back
  end
end