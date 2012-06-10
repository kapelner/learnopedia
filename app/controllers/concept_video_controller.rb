class ConceptVideoController < ApplicationController
  def add
    cv = ConceptVideo.create({
      :video => params[:concept_video][:video],
      :description => params[:concept_video][:description],
      :concept_bundle_id => params[:concept_video][:cb_id]
    })
    flash[:error] = "Sorry, this type of video file is not supported." unless cv.valid?
    redirect_to :back
  end
end