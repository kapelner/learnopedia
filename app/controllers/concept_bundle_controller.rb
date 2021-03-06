class ConceptBundleController < ApplicationController
  include ParseAndRewriteTools

  before_filter :authenticate_user!, :except => :video_and_question_window
  
  def add
    #dejsonify the cb_ids
    page_id = params[:concept_bundle][:page_id]
    cb_ids = JSON.parse(params[:concept_bundle][:cb_ids])
    cb_id_hash = cb_ids.inject({}){|hash, cb_id| hash[cb_id.to_i] = 1; hash}
    cb = ConceptBundle.create({
      :page_id => page_id,
      :title => ConceptBundle::Untitled,
      :contributor_id => current_user.id,
      :bundle_elements_hash => cb_id_hash
    })
    redirect_to :action => :index, :id => cb.id
  end

  def edit_title
    @cb = ConceptBundle.find(params[:id])
    @cb.update_attributes(params[:concept_bundle])
    render :nothing => true
  end

  def index
    @cb = ConceptBundle.find(params[:id], :include => :page)
    #now we need to get the html correct
    html_with_links_rewritten = rewrite_links_to_wikipedia_or_learnopedia(@cb.page, :contributor => true)
    html_with_bundle_spans = add_bundle_element_tags(@cb.page, html_with_links_rewritten)
    @html_with_only_cb_showing = hide_page_except_for_cb(@cb, html_with_bundle_spans)
  end

  def video_and_question_window
    @cb = ConceptBundle.find(params[:id], :include => [{:questions => :answers}, :concept_videos])
    @contributor = params[:contributor] == "true"
    render :layout => false #ajax
  end

  def delete
    cb = ConceptBundle.find(params[:id])
    cb.destroy
    redirect_to :controller => :page, :action => :contributor_view, :id => cb.page.id
  end
end
