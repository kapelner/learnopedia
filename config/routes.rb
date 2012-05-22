Learnopedia::Application.routes.draw do

  devise_for :users

  mount RailsAdmin::Engine => '/dbadmin', :as => 'rails_admin'

  root :to => 'page#index'

  match "about" => "welcome#about"
  match "contribute" => "welcome#contribute"
  
  get "welcome/about"
  get "welcome/contribute"
  get "page/student_view"
  get "page/contributor_view"
  post "page/contributor_view"
  post "page/add_prerequisite"
  
end
