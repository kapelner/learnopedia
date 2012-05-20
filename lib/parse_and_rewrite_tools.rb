module ParseAndRewriteTools

  TagsThatAreNotAddableToCBs = %w(h1 h2 h3 h4 h5 table tbody td tr th)
  TagsThatAreNotSeparableFromText = %w(img sup sub a)

  #Things that should be deleted from all wikipedia pages:
  #1) The "[edit]" links

  def rewrite_links_to_wikipedia_or_learnopedia
    @learnopedia_html = html
    #TO-DO
  end

  def tag_all_text_blocks_with_possible_cb_tag
    #TO-DO
  end

  def assign_text_blocks_to_cb(cb)
    #TO-DO
  end
  
end
