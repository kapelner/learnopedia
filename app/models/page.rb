class Page < ActiveRecord::Base
  has_paper_trail

  extend Wikipedia
  include ParseAndRewriteTools
  
  has_many :concept_bundles, :dependent => :destroy
  has_and_belongs_to_many :prerequisites

  def Page.create_learnopedia_page_by_url!(nokogiri_doc)
    Page.create({
      :url => nokogiri_doc.url,
      :html => parse_content_from_wikipedia_article(nokogiri_doc),
      :title => parse_title_from_wikipedia_article(nokogiri_doc),
      :wiki_name => nokogiri_doc.url.split("/").last
    })
  end

  def no_content?
    self.concept_bundles.empty?
  end

  def concept_bundles_in_text_order
    self.concept_bundles.sort_by do |cb|
      cb.bundle_elements_hash.keys.first
    end
  end
  
  def add_prerequisite!(url)
    self.prerequisites << Prerequisite.create(:url => url, :title => Page.parse_title_from_wikipedia_article(Nokogiri::HTML(open(url))))
  end

  def wikihtml_links_rewritten_concept_bundles_added_their_text_highlighted(options = {})
    html_with_links_rewritten = rewrite_links_to_wikipedia_or_learnopedia(self, options)
    add_bundle_element_tags(self, html_with_links_rewritten, options).to_s
  end

end