class ConceptVideoController < ApplicationController
  def add
    cv = ConceptVideo.create({
      :video => params[:concept_video][:video],
      :concept_bundle_id => params[:concept_video][:cb_id]
    })
    flash[:error] = "Sorry, this filetype is not supported" unless cv.valid?
    redirect_to :back
  end
end