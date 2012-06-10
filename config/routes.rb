Learnopedia::Application.routes.draw do

  devise_for :users

  mount RailsAdmin::Engine => '/dbadmin', :as => 'rails_admin'

  root :to => 'welcome#index'

  match "about" => "welcome#about"
  match "contribute" => "welcome#contribute"
  match "coolpage" => "page#coolpage"
  
  get "welcome/about"
  get "welcome/contribute"
  get "page/search_or_add"
  get "page/does_not_exist"
  get "page/student_view"
  get "page/contributor_view"
  post "page/contributor_view"
  post "page/delete_page"
  post "page/add_prerequisite"
  post "concept_bundle/add"
  put "concept_bundle/edit_title"
  get "concept_bundle/index"
  get "concept_bundle/video_and_question_window"
  delete "concept_bundle/delete"
  post "concept_video/add"
  post "question/add"
  put "question/edit"
  post "question/delete"
  post "question/search"
  get "answer/index"
  post "answer/add"
  post "answer/edit"
  post "answer/delete"
end
