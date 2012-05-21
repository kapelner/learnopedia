class ConceptBundle < ActiveRecord::Base
  has_many :questions #do not destroy on 
  belongs_to :page
end
