class ConceptVideo < ActiveRecord::Base
  has_paper_trail

  belongs_to :concept_bundle

  mount_uploader :video, VideoUploader  

  validates :desciption, :presence => true

  searchable {text :description}
end
