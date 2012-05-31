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

    doc
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
  def add_bundle_element_tags(doc_with_rewritten_links)
    #first get the html and get just the relevant part of the body
    root_where_content_first_appears = doc_with_rewritten_links.xpath("//div[@id='mw-content-text']").first
    #set the counter
    @num_tags_thus_far = 0

    #now start the recursion process
    tag_all_words_with_cb_tag(root_where_content_first_appears, doc_with_rewritten_links)
    #since we modified the nokogiri doc, all we have to do is send back the new one
    doc_with_rewritten_links.to_s
  end


  TagsThatAreNotAddableToCBs = %w(h1 h2 h3 h4 h5 table tbody td tr th html pre)
  TagsThatConstituteBundle = %w(text img sup sub a comment i b u code span)

  def node_is_bundleable?(node)
    #if node is bundleable, all its children have names that are in that array
    node.children.each do |child|
      return false unless child.name.in?(TagsThatConstituteBundle)
    end
    #if node is bundleable, then its tag must be addable
    return false if node.name.in?(TagsThatAreNotAddableToCBs)
#    puts "\n\n dl or dd text: blank? #{node.text.strip.blank?} #{node.to_s}" if node.name.in?(%w(dl dd))
    #if node is empty, ie there's a bunch of whitespace, return false as well
    return false if node.text.strip.blank? and !node.name.in?(%w(dd dl img))
    true
  end

  

  def tag_all_words_with_cb_tag(node, doc)    
    if node_is_bundleable?(node)
      #iterate over children and make a node set for each child
      new_children_as_node_array = node.children.map do |ch|
        create_cb_tags_for_bundleable_node(ch, doc)
      end.flatten
      #now set this nodeset equal to the bundleable node's children
      node.children = Nokogiri::XML::NodeSet.new(doc, new_children_as_node_array)
    elsif !node.name.in?(TagsThatAreNotAddableToCBs)
      #just recurse to the point where the node is bundleable...
      node.children.each do |ch|
        tag_all_words_with_cb_tag(ch, doc)
      end
    end
  end

  def create_cb_tags_for_bundleable_node(node, doc)
    
    if node.text?
      text_cb_tags = node.text.split(/\s/).map{|text_bundle| create_cb_tag_node_from_text(text_bundle, doc)}
      text_cb_tags.map{|node| [node, Nokogiri::XML::Text.new("\n", doc)]}.flatten
    else      
      create_cb_tag_node_from_text(node.to_s, doc)
    end
  end

  ActiveBundleClass = "learnopedia_bundle_element_active"
  
  def create_cb_tag_node_from_text(text, doc)
    cb_tag = Nokogiri::XML::Node.new('span', doc)
    #is it part of a context bundle?? TO-DO
    #    self.concept_bundles.each{|cb| assign_text_blocks_to_cb(cb)}
    cb_tag['class'] = "#{ActiveBundleClass}_tag#{@num_tags_thus_far % 3 + 1}"
    cb_tag['id'] = "bundle_element_#{@num_tags_thus_far}"
    cb_tag.inner_html = text

#    puts "TAG ##{@num_tags_thus_far} cb_tag class: #{cb_tag.class} text: #{text}"
    @num_tags_thus_far += 1
    cb_tag
  end
  
end