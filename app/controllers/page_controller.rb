class PageController < ApplicationController
  include Wikipedia
  
  before_filter :authenticate_user!, :only => [:contributor_view, :delete_page]
  
  CoolPages = ["Kernel density estimation"]
  def coolpage
    redirect_to :action => :student_view, :id => (Page.find_by_title(CoolPages.sample) || Page.first).id
  end

  def search_or_add
    @page = Page.find_by_title(params[:page][:title])
    if @page.nil?
      if user_signed_in?
        #work on actually adding the page
        doc = query_en_wikipedia(params[:page][:title])
        if no_wikipedia_article_by_title?(doc)
          #if not, we need to send them to a special search page
          raise "no wikipedia article by title #{params[:page][:title]}"
        else
          #if it was actually a page, go ahead and add it to the db
          page = Page.create_learnopedia_page_by_url!(doc)
          redirect_to :action => :contributor_view, :id => page.id
        end
      else
        #send them to a redirect page with a message
        session[:title] = params[:page][:title]
        redirect_to :action => :does_not_exist
      end
    else
      #if it exists, great, route them there
      redirect_to :action => :student_view, :id => @page.id
    end
  end

  def does_not_exist
    @title = session[:title]
  end

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
