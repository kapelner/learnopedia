class ConceptVideo < ActiveRecord::Base
  has_paper_trail

  belongs_to :concept_bundle

  mount_uploader :video, VideoUploader

  searchable {text :description}
end
