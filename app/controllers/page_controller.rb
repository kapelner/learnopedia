class PageController < ApplicationController
  before_filter :authenticate_user!, :only => [:contributor_view]
  
  def index
    if request.post?
      authorize! :create, Page
      @page = Page.create_learnopedia_page_by_url!(params[:newpage][:url])
    end
    @pages = Page.all
  end

  def contributor_view
    @page = Page.find(params[:id])        
  end

  def add_prerequisite
    authorize! :create, Prerequisite
    @page = Page.find(params[:new_prerequisite][:page_id])
    @page.add_prerequisite!(params[:new_prerequisite][:url])
    redirect_to :action => :contributor_view, :id => @page.id
  end

  def student_view
    @page = Page.find(params[:id])
  end

  def student_or_contributor_view
    redirect_to :action => (user_signed_in? ? :contributor_view : :student_view), :id => params[:id]
  end

  def add_concept_bundle
    #dejsonify the cb_ids
    page_id = params[:concept_bundle][:page_id]
    cb_ids = JSON.parse(params[:concept_bundle][:cb_ids])
    cb_id_hash = cb_ids.inject({}){|hash, cb_id| hash[cb_id.to_i] = 1; hash}
    cb = ConceptBundle.create({
      :page_id => page_id,
      :contributor_id => current_user.id,
      :bundle_elements_hash => cb_id_hash
    })
    redirect_to :action => :manage_concept_bundle, :id => cb.id
  end

  def manage_concept_bundle
    @cb = ConceptBundle.find(params[:id])
  end

  #http://www.mathjax.org/demos/mathml-samples/ (for rendering latex)
end
