class WelcomeController < ApplicationController

  def about

  end

  def contribute
    #basically a sign up page
  end

  def index
    @pages = Page.all if user_signed_in?
  end
end
