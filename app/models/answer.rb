class Answer < ActiveRecord::Base
  has_paper_trail

  belongs_to :question
  belongs_to :contributor, :class_name => 'User'
  
end
