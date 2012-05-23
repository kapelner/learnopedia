module ParseAndRewriteTools

  TagsThatAreNotAddableToCBs = %w(h1 h2 h3 h4 h5 table tbody td tr th)
  TagsThatAreNotSeparableFromText = %w(img sup sub a)

  #Things that should be deleted from all wikipedia pages:
  #1) The "[edit]" links

  def rewrite_links_to_wikipedia_or_learnopedia(is_contributor)
    #titles_to_id_hash = Page.all.inject({}){|hash, p| hash[p.title] = p.id; hash}
    pages = Page.all
    titles_to_id = Hash[pages.map{|p| p.wiki_name}.zip(pages.map{|p| p.id})]
    #titles_to_id.contains?("QWuadratasdfmasdpf")

    doc = Nokogiri::HTML(self.html)
    
    #Remove edit links
    doc.xpath("//span[@class='editsection']").each {|edit| edit.remove}

    #Point links to learnopedia if the articles are in our database
    point_wiki_links_to_the_right_place(doc, titles_to_id, is_contributor)

    @learnopedia_html = doc.to_s

    #TO-DO
  end

  def point_wiki_links_to_the_right_place(doc, known_title_id_hash, is_contributor)
    wiki_link_start = "http://en.wikipedia.org"
    linkstart = "page"
    student_link = "student_view"
    contributor_link = "contributor_view"
    doc.xpath("//a").each do |link|
      if link.has_attribute? "href"
        link["target"] ="_blank"
        link_value = link.attributes["href"].value
        if link_value.start_with?("/wiki")
          wiki_name = link_value.split("/").last
          if known_title_id_hash[wiki_name]
            link_value = %Q{/#{linkstart}/#{is_contributor ? contributor_link : student_link}?id=#{known_title_id_hash[wiki_name]}}
          else
            link_value = wiki_link_start + link_value
          end
        end
        link.attributes["href"].value = link_value
      end
    end
  end

  def tag_all_text_blocks_with_possible_cb_tag
    #TO-DO
  end

  def assign_text_blocks_to_cb(cb)
    #TO-DO
  end
  

end