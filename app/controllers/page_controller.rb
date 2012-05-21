class PageController < ApplicationController

  def index    
    if request.post?
      @page = Page.create_learnopedia_page_by_url!(params[:newpage][:url])
    end
    @pages = Page.all
  end

  def contributor_view
    @page = Page.find(params[:id])        
  end

  def add_prerequisite
    @page = Page.find(params[:new_prerequisite][:page_id])
    @page.add_prerequisite!(params[:new_prerequisite][:url])
    redirect_to :action => :contributor_view, :id => @page.id
  end

  def student_view
    @page = Page.find(params[:id])
  end
end
