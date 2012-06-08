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
  delete "page/delete_page"
  post "page/add_prerequisite"
  post "concept_bundle/add"
  put "concept_bundle/edit_title"
  get "concept_bundle/index"
  get "concept_bundle/video_and_question_window"
  post "concept_video/add"
  post "question/add"
  post "question/edit"
end
