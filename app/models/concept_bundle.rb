class ConceptBundle < ActiveRecord::Base
  has_many :questions
  belongs_to :page
end
