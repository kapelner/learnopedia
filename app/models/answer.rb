class Answer < ActiveRecord::Base
  has_paper_trail

  belongs_to :question
end
