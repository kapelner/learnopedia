class ConceptVideo < ActiveRecord::Base
  mount_uploader :video, VideoUploader

  belongs_to :concept_bundle
end
