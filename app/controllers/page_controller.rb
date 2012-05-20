class PageController < ApplicationController

  def index    
    if request.post?
      @page = Page.create_learnopedia_page_by_url!(params[:newpage][:url])
    end
    @pages = Page.all
  end

  def concept_bundle_interface
    @page = Page.find(params[:id])        
  end

  def view
    @page = Page.find(params[:id])
  end
end
