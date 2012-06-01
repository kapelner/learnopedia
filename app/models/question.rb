class Question < ActiveRecord::Base
  has_paper_trail

  has_many :answers, :dependent => :destroy
  belongs_to :concept_bundle
end
