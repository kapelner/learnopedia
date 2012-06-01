class ConceptBundle < ActiveRecord::Base
  has_paper_trail
  
  has_many :questions #do not destroy on 
  belongs_to :page

  serialize :bundle_elements_hash
end
