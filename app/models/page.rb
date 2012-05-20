require 'open-uri'

class Page < ActiveRecord::Base
  has_many :concept_bundles

  include ParseAndRewriteTools

  def Page.create_learnopedia_page_by_url!(url)
    doc = Nokogiri::HTML(open(url))
    Page.create({
      :html => doc.xpath("//div[@id='content']").to_s,
      :title => doc.xpath("//h1[@id='firstHeading']").xpath("//span[@dir='auto']").inner_html
    })
  end

  attr_accessor :learnopedia_html
  def wikihtml_links_rewritten_concept_bundles_added_their_text_highlighted
    rewrite_links_to_wikipedia_or_learnopedia
    tag_all_text_blocks_with_possible_cb_tag
    self.concept_bundles.each{|cb| assign_text_blocks_to_cb(cb)}
    @learnopedia_html
  end
  
end