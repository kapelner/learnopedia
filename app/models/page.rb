require 'open-uri'

class Page < ActiveRecord::Base
  has_many :concept_bundles, :dependent => :destroy
  has_and_belongs_to_many :prerequisites

  include ParseAndRewriteTools

  def Page.create_learnopedia_page_by_url!(url)
    doc = Nokogiri::HTML(open(url))
    Page.create({
      :url => url,
      :html => parse_content_from_wikipedia_article(doc),
      :title => parse_title_from_wikipedia_article(doc)
    })
  end

  def add_prerequisite!(url)
    self.prerequisites << Prerequisite.create(:url => url, :title => parse_title_from_wikipedia_article(Nokogiri::HTML(open(url))))
  end

  attr_accessor :learnopedia_html
  def wikihtml_links_rewritten_concept_bundles_added_their_text_highlighted
    rewrite_links_to_wikipedia_or_learnopedia
    tag_all_text_blocks_with_possible_cb_tag
    self.concept_bundles.each{|cb| assign_text_blocks_to_cb(cb)}
    @learnopedia_html
  end

  private
  def parse_title_from_wikipedia_article(nokogiri_doc)
    nokogiri_doc.xpath("//h1[@id='firstHeading']").xpath("//span[@dir='auto']").inner_html
  end

  def parse_content_from_wikipedia_article(nokogiri_doc)
    nokogiri_doc.xpath("//div[@id='content']").to_s
  end  
end