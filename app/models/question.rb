class Question < ActiveRecord::Base
  has_paper_trail

  has_many :answers, :dependent => :destroy
  has_and_belongs_to_many :concept_bundles
#  has_many :concept_bundles_questions
#  has_many :concept_bundles, :through => :concept_bundles_questions
  belongs_to :contributor, :class_name => 'User'

  searchable {text :question_text}

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

  SampleText = <<SAMP
This is a sample question that uses inline math \\(a^2 + b^2 = c^2\\) as well as block math $$\\frac{1}{\\sqrt{2\\pi\\sigma^2}}e^{-\\frac{1}{2\\sigma^2} (x - \\mu)^2}$$
SAMP

  def difficulty_level_text
    "[#{DifficultyLevels[self.difficulty_level]}]"
  end
  
end
