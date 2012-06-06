class PageController < ApplicationController
  before_filter :authenticate_user!, :only => [:contributor_view, :delete_page]
  
  def index
    if request.post?
      authorize! :create, Page
      url = params[:newpage][:url]
      unless url.start_with?("en.wikipedia.org/wiki") or url.start_with?("http://en.wikipedia.org/wiki")
        flash.now[:error] = "Page must be an English Wikipedia page."
      else
        @page = Page.create_learnopedia_page_by_url!(params[:newpage][:url])
      end
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

  def delete_page
    Page.find(params[:id]).destroy
    redirect_to :action => :index
  end

  #http://www.mathjax.org/demos/mathml-samples/ (for rendering latex)
end
