module ParseAndRewriteTools

  #Things that should be deleted from all wikipedia pages:
  #1) The "[edit]" links

  def rewrite_links_to_wikipedia_or_learnopedia(page, options)
    #titles_to_id_hash = Page.all.inject({}){|hash, p| hash[p.title] = p.id; hash}
    pages = Page.all
    titles_to_id = Hash[pages.map{|p| p.wiki_name}.zip(pages.map{|p| p.id})]

    doc = Nokogiri::HTML(page.html)
    
    #Remove edit links
    doc.xpath("//span[@class='editsection']").each {|edit| edit.remove}

    #Point links to learnopedia if the articles are in our database
    point_wiki_links_to_the_right_place(doc, titles_to_id, options)

    doc
  end

  def point_wiki_links_to_the_right_place(doc, known_title_id_hash, options)
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
            link_value = %Q{/#{linkstart}/#{options[:contributor] ? contributor_link : student_link}?id=#{known_title_id_hash[wiki_name]}}
          else
            link_value = wiki_link_start + link_value
          end
        end
        link.attributes["href"].value = link_value
      end
    end
  end

  attr_accessor :num_tags_thus_far
  def add_bundle_element_tags(page, doc_with_rewritten_links, options)
    #first get the html and get just the relevant part of the body
    root_where_content_first_appears = doc_with_rewritten_links.xpath("//div[@id='mw-content-text']").first
    #set the counter
    @num_tags_thus_far = 0

    #now start the recursion process
    tag_all_words_with_cb_tag(page, root_where_content_first_appears, doc_with_rewritten_links, options)
    add_cb_window_to_each_cb_html_block(page, doc_with_rewritten_links, options)

    #since we modified the nokogiri doc, all we have to do is send back the new one
    doc_with_rewritten_links
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

  

  def tag_all_words_with_cb_tag(page, node, doc, options)
    if node_is_bundleable?(node)
      #iterate over children and make a node set for each child
      new_children_as_node_array = node.children.map do |ch|
        create_cb_tags_for_bundleable_node(page, ch, doc, options)
      end.flatten
      #now set this nodeset equal to the bundleable node's children
      node.children = Nokogiri::XML::NodeSet.new(doc, new_children_as_node_array)
    elsif !node.name.in?(TagsThatAreNotAddableToCBs)
      #just recurse to the point where the node is bundleable...
      node.children.each do |ch|
        tag_all_words_with_cb_tag(page, ch, doc, options)
      end
    end
  end

  def create_cb_tags_for_bundleable_node(page, node, doc, options)
    if node.text?
      text_cb_tags = node.text.split(/\s/).map{|text_bundle| create_cb_tag_node_from_text(page, text_bundle, doc, options)}
      text_cb_tags.map{|node| [node, Nokogiri::XML::Text.new("\n", doc)]}.flatten
    else      
      create_cb_tag_node_from_text(page, node.to_s, doc, options)
    end
  end

  ActiveBundleClass = "learnopedia_bundle_element_active"
  InActiveBundleClass = "learnopedia_bundle_element_inactive"
  
  def create_cb_tag_node_from_text(page, text, doc, options)
    cb_tag = Nokogiri::XML::Node.new('span', doc)    
    cb_tag['class'] = "#{InActiveBundleClass}"
    cb_tag['cb_id'] = "#{@num_tags_thus_far}"
    cb_tag.inner_html = text

    #if it's part of a concept bundle already, we need to mark it so and give it an ordinal number
    page.concept_bundles.each_with_index do |cb, i|
      if cb.bundle_elements_hash[@num_tags_thus_far]
        cb_tag['class'] = "#{ActiveBundleClass} #{ActiveBundleClass}_#{i + 1}"
        cb_tag['cb_active_tag_num'] = (i + 1).to_s
      end
    end

#    puts "TAG ##{@num_tags_thus_far} cb_tag class: #{cb_tag.class} text: #{text}"
    @num_tags_thus_far += 1
    cb_tag
  end

  ProblemAndVideoWindowClass = "problem_and_video_window"
  def add_cb_window_to_each_cb_html_block(page, doc, options)
    #first find all concept bundle tags
    
    page.concept_bundles.each_with_index do |cb, i|
      #first create the div tag itself
      pvw_wrap_tag = Nokogiri::XML::Node.new('span', doc)
      pvw_wrap_tag['id'] = "#{ProblemAndVideoWindowClass}_#{i + 1}"
      pvw_wrap_tag['real_cb_id'] = cb.id.to_s
      #then get the tags
      all_cb_tags = doc.xpath("//span[contains(@class, '#{ActiveBundleClass}_#{i + 1}')]")
      #now add the div at the end of the last span
      all_cb_tags.last.add_next_sibling(pvw_wrap_tag)
    end
  end

  TagsThatCannotBeHidden = %w(html body)
  def hide_page_except_for_cb(cb, doc)
    #first hide absolutely everything except the essentials
    doc.xpath("//*").each do |html_tag|
      next if html_tag.name.in?(TagsThatCannotBeHidden)
      html_tag['style'] = 'display:none'
    end
    #now unhide all concept bundle tags
    (doc.xpath("//span[contains(@class, '#{ActiveBundleClass}')]") + doc.xpath("//span[@class='#{InActiveBundleClass}']")).each do |cb_tag|
      #kill the active tag that makes it a color first
      cb_tag['class'] = ActiveBundleClass
      #if this tag IS part of the cb of interest, make it AND its parents appear
      if cb.bundle_elements_hash[cb_tag['cb_id'].to_i]
        make_tag_and_all_parents_appear(cb_tag)
        make_tag_and_all_children_appear(cb_tag)
      end
    end
    doc
  end

  def make_tag_and_all_parents_appear(tag)
    tag['style'] = ''
    if tag.name != "document" and tag.parent.present?
      make_tag_and_all_parents_appear(tag.parent)
    end
    
  end

  def make_tag_and_all_children_appear(tag)
    tag['style'] = ''
    tag.children.each{|ch| make_tag_and_all_children_appear(ch)}
  end
  
end