class PageController < ApplicationController

  def index    
    if request.post?
      @page = Page.create_learnopedia_page_by_url!(params[:newpage][:url])
    end
    @pages = Page.all
  end

  def instructor_interface
    @page = Page.find(params[:id])
  end

  def raw_wikipedia_page
    render :text => Page.find(params[:id]).html_with_links_rewritten
  end
end
