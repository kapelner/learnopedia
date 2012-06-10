class ConceptBundlesQuestion < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :concept_bundle
  belongs_to :question
end