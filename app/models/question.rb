class Question < ActiveRecord::Base
  has_paper_trail

  has_many :answers, :dependent => :destroy
  belongs_to :concept_bundle
  belongs_to :contributor, :class_name => 'User'

  DifficultyLevels = {
    'a' => 'Super Easy',
    'b' => 'Easy',
    'c' => 'Intermediate',
    'd' => 'Difficult',
    'e' => 'Very Difficult',
    'f' => 'Almost Impossible'
  }
  validates :question_text, :presence => true
  validates :difficulty_level, :inclusion => {:in => DifficultyLevels.keys}
end
