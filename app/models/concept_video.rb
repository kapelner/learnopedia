class ConceptVideo < ActiveRecord::Base
  mount_uploader :video, VideoUploader
end
