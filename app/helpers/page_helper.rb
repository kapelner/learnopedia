module PageHelper

  def title_link_to_prerequisite(prereq, contributor)
    #if this article appears in our database, navigate there, otherwise go to wikipedia
    possible_page = Page.find_by_url(prereq.url)
    link_to(prereq.title, possible_page ? "page##{contributor ? "contributor" : "student"}_view/#{possible_page.id}" : prereq.url, :target => "_blank")
  end
end
