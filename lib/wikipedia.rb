require 'open-uri'

module Wikipedia
  
  
  WikipediaSearch = "http://en.wikipedia.org/w/index.php?search="
    
  def query_en_wikipedia(title)
    Nokogiri::HTML(open(URI.escape(WikipediaSearch + title)))
  end

  def no_wikipedia_article_by_title?(nokogiri_doc)
    parse_title_from_wikipedia_article(nokogiri_doc).downcase.strip == "search results"
  end

  def parse_title_from_wikipedia_article(nokogiri_doc)
    nokogiri_doc.xpath("//h1[@id='firstHeading']").xpath("//span[@dir='auto']").inner_html
  end

  def parse_content_from_wikipedia_article(nokogiri_doc)
    nokogiri_doc.xpath("//div[@id='content']/div[@id='bodyContent']").to_s
  end


end
