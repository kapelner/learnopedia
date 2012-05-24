require 'open-uri'

class Page < ActiveRecord::Base
  has_many :concept_bundles, :dependent => :destroy
  has_and_belongs_to_many :prerequisites

  include ParseAndRewriteTools

  def Page.create_learnopedia_page_by_url!(url)
    doc = Nokogiri::HTML(open(url))
    Page.create({
      :url => url,
      :html => Page.parse_content_from_wikipedia_article(doc),
      :title => Page.parse_title_from_wikipedia_article(doc),
      :wiki_name => url.split("/").last
    })
  end

  def add_prerequisite!(url)
    self.prerequisites << Prerequisite.create(:url => url, :title => Page.parse_title_from_wikipedia_article(Nokogiri::HTML(open(url))))
  end

  def wikihtml_links_rewritten_concept_bundles_added_their_text_highlighted(is_contributor)
    add_bundle_element_tags(rewrite_links_to_wikipedia_or_learnopedia(is_contributor))
  end

  private
  def Page.parse_title_from_wikipedia_article(nokogiri_doc)
    nokogiri_doc.xpath("//h1[@id='firstHeading']").xpath("//span[@dir='auto']").inner_html
  end

  def Page.parse_content_from_wikipedia_article(nokogiri_doc)
    nokogiri_doc.xpath("//div[@id='content']/div[@id='bodyContent']").to_s
  end  
end