class ConceptBundle < ActiveRecord::Base
  has_paper_trail
  
  has_many :questions #do not destroy these on cb destroy
  has_many :concept_videos
  belongs_to :page

  serialize :bundle_elements_hash

  def summary_stats
    stats = []
    if self.concept_videos.any?
      stats << "#{self.concept_videos.length} Videos"
    end
    if self.questions.any?
      stats << "#{self.questions.length} Questions"
      num_answers = self.questions.sum{|q| q.answers.length}
      unless num_answers.zero?
        stats << "#{num_answers} Answers"
      end
    end
    stats << "No videos or questions yet." if stats.empty?
    stats.join(' ')
  end
end
