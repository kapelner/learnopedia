class ConceptVideo < ActiveRecord::Base
  has_paper_trail

  mount_uploader :video, VideoUploader

  belongs_to :concept_bundle
end
