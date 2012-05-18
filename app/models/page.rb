require 'open-uri'

class Page < ActiveRecord::Base
  has_many :concept_bundles

  include ParseTools

  def Page.create_learnopedia_page_by_url!(url)
    doc = Nokogiri::HTML(open(url))
    Page.create({
      :html => doc.xpath("//div[@id='content']").to_s,
      :title => doc.xpath("//h1[@id='firstHeading']").xpath("//span[@dir='auto']").inner_html
    })
  end

  def html_with_links_rewritten
    html
  end

  def delimit_the_html
    all_splits = html_with_links_rewritten.split(/\s/)
    all_splits.join(' ')
  end
end
