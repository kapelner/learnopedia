class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :concept_bundle
end
