class ConceptBundle < ActiveRecord::Base
  has_paper_trail

  has_and_belongs_to_many :questions
#  has_many :concept_bundles_questions
#  has_many :questions, :through => :concept_bundles_questions
  
  has_many :concept_videos
  belongs_to :page
  belongs_to :contributor, :class_name => 'User'

  serialize :bundle_elements_hash

  def questions_with_answers
    self.questions.select{|q| q.answers.any?}
  end

  def questions_by_difficulty
    self.questions.sort_by{|cb| cb.difficulty_level}
  end

  def questions_with_answers_by_difficulty
    self.questions_with_answers.sort_by{|cb| cb.difficulty_level}
  end

  def no_content?
    self.concept_videos.empty? and self.questions_with_answers.empty?
  end

  Untitled = "[Untitled]"
  def untitled?
    self.title == Untitled
  end

  def summary_stats
    stats = []
    if self.concept_videos.any?
      stats << "#{self.concept_videos.length} Videos"
    end
    if self.questions_with_answers.any?
      stats << "#{self.questions_with_answers.length} Questions"
      num_answers = self.questions_with_answers.sum{|q| q.answers.length}
      unless num_answers.zero?
        stats << "#{num_answers} Answers"
      end
    end
    stats << "No videos or questions yet." if stats.empty?
    (self.untitled? ? "" : "#{self.title}:  ") + stats.join(' ')
  end
end
