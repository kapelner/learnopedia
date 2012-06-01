class Prerequisite < ActiveRecord::Base
  has_paper_trail

  has_and_belongs_to_many :pages

end
