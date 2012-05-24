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
    @num_tags_thus_far = 1

    #now start the recursion process
    tag_all_text_blocks_with_possible_cb_tag(root_where_content_first_appears, doc_with_rewritten_links)
    #since we modified the nokogiri doc, all we have to do is send back the new one
    doc_with_rewritten_links.to_s
  end

  ActiveBundleClass = "learnopedia_bundle_element_active"
  def assign_bundle_tag(nodes, doc)
    return if nodes.empty?

    #first create the new node with proper class and id
    bundle_tag = Nokogiri::XML::Node.new('span', doc)
    #is it part of a context bundle?? TO-DO
    #    self.concept_bundles.each{|cb| assign_text_blocks_to_cb(cb)}
    bundle_tag['class'] = "#{ActiveBundleClass}_tag#{@num_tags_thus_far % 3 + 1}"
    bundle_tag['id'] = "bundle_element_#{@num_tags_thus_far}"

    #first get the parent's children
    mamas_children = nodes.first.parent.children
    #now find index of where this first node lived
    first_loc = mamas_children.index(nodes.first)
    last_loc = mamas_children.index(nodes.last)
    #now set the children manually to not screw up the order
    #we have to go through these gymnastics because the children's setter needs a NodeSet not just an array of Nodes
    new_children = Nokogiri::XML::NodeSet.new(doc, mamas_children[0...first_loc] + Nokogiri::XML::NodeSet.new(doc, [bundle_tag]) + mamas_children[(last_loc + 1)..-1])

    nodes.first.parent.children = new_children

    #now we need to add the nodes in this bundle to our new tag
    nodes.each do |node|
      #last thing we do... for each node...
      bundle_tag.add_child(node)
      
    end

#    puts "\nTAG ##{@num_tags_thus_far} children_names: #{nodes.map{|node| node.name}} mama_name: #{mamas_original_name}\nTEXT OF BUNDLEABLE NODE: #{bundle_tag.text}"
    @num_tags_thus_far += 1
  end

=begin
page = Page.first; nil
doc = Nokogiri::HTML(page.html); nil
root_where_content_first_appears = doc.xpath("//div[@id='mw-content-text']").first; nil

ps = root_where_content_first_appears.xpath("//p"); nil
=end

  def tag_all_text_blocks_with_possible_cb_tag(node, doc)
#    return if @num_tags_thus_far > 20

    if node.children.any?
      #now we go hunting for children that are "bundleable bunches"
      last_bunch = []
      node.children.each do |child|
        if node_is_bundleable?(child)
          last_bunch << child
        else
          #3 steps
          #1. combine the last bunch into a bundle (if there is anything to begin with)
          if last_bunch.any?
            if last_bunch.length == 1
              last_bunch = last_bunch.first.children
            end
            assign_bundle_tag(last_bunch, doc)
#            puts "ran through intermediate"
          end
          #2. reset last bunch
          last_bunch = []
          #3. since this child was not bundleable, do the recursion if necessary
          unless child.name.in?(TagsThatAreNotAddableToCBs)
            tag_all_text_blocks_with_possible_cb_tag(child, doc)
          end
        end
      end
      assign_bundle_tag(last_bunch, doc) if last_bunch.any?
#      p "last_bunch at bottom: #{last_bunch.map{|node| node.name}}"
    elsif node_is_bundleable?(node)
      assign_bundle_tag(node)
#      p "ran through failsafe"
    end
    
#    if node_is_bundleable?(node)
#      assign_bundle_tag([node], doc)
#    else
#      #iterate over all the children
#      node.children.each do |child|
#        #if the tag is evil, don't recurse, otherwise recurse
#        unless TagsThatAreNotAddableToCBs.include?(child.name)
#          tag_all_text_blocks_with_possible_cb_tag(child, doc)
#        end
#      end
#    end
  end

  TagsThatAreNotAddableToCBs = %w(h1 h2 h3 h4 h5 table tbody td tr th html)
  TagsThatConstituteBundle = %w(text img sup sub a comment i b u code dl dd span)

  def node_is_bundleable?(node)
    #if node is bundleable, all its children have names that are in that array
    node.children.each do |child|
      return false unless child.name.in?(TagsThatConstituteBundle)
    end
    #if node is bundleable, then its tag must be addable
    return false if node.name.in?(TagsThatAreNotAddableToCBs)
    #if node is empty, ie there's a bunch of whitespace, return false as well
    return false if node.text.strip.blank? and node.name != "img"
    true
  end

end