module ParseAndRewriteTools



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

  attr_accessor :num_tags_thus_far
  def add_bundle_element_tags
    doc = Nokogiri::HTML(self.html)
    @num_tags_thus_far = 1
    tag_all_text_blocks_with_possible_cb_tag(doc.xpath("//div[@id='mw-content-text']").first)
  end

  def tag_all_text_blocks_with_possible_cb_tag(node)
    return if @num_tags_thus_far > 10
    
    if node_is_bundleable?(node)
      assign_bundle_tag(node)
    else
      #iterate over all the children
      node.children.each do |child|
        #if the tag is evil, don't recurse, otherwise recurse
        unless TagsThatAreNotAddableToCBs.include?(child.name)
          tag_all_text_blocks_with_possible_cb_tag(child)
        end
      end
    end
  end

  TagsThatAreNotAddableToCBs = %w(h1 h2 h3 h4 h5 table tbody td tr th html)
  TagsThatConstituteBundle = %w(text img sup sub a comment)

  def node_is_bundleable?(node)
    #if node is bundleable, all its children have names that are in that array
    node.children.each do |child|
      return false unless child.name.in?(TagsThatConstituteBundle)
    end
    #if node is bundleable, then its tag must be addable
    return false if node.name.in?(TagsThatAreNotAddableToCBs)
    #if node is empty, ie there's a bunch of whitespace, return false as well
    return false if node.text.strip.blank?

    true
  end

  def assign_bundle_tag(node)
    p "TAG ##{@num_tags_thus_far} TEXT OF BUNDLEABLE NODE: #{node.text}"
    @num_tags_thus_far += 1
  end



#    self.concept_bundles.each{|cb| assign_text_blocks_to_cb(cb)}

#  def add_cb_tag(id, inner_html)
#    %Q|<span class="learnopedia_cb" id="learnopedia_cb_#{id}">#{inner_html}</span>|
#  end
  

end