class Question < ActiveRecord::Base
  has_paper_trail

  has_many :answers, :dependent => :destroy
  belongs_to :concept_bundle
  belongs_to :contributor, :class_name => 'User'

  DifficultyLevels = {
    'a' => 'Super easy',
    'b' => 'Easy',
    'c' => 'Intermediate',
    'd' => 'Difficult',
    'e' => 'Very difficult',
    'f' => 'Almost impossible'
  }
  validates :question_text, :presence => true
  validates :difficulty_level, :inclusion => {:in => DifficultyLevels.keys}

  def difficulty_level_text
    "[#{DifficultyLevels[self.difficulty_level]}]"
  end
#  scope :questions_with_answers 
end
