class ConceptBundle < ActiveRecord::Base
  has_paper_trail
  
  has_many :questions #do not destroy these on cb destroy
  belongs_to :page

  serialize :bundle_elements_hash
end
