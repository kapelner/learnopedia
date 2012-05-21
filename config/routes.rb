Learnopedia::Application.routes.draw do

  mount RailsAdmin::Engine => '/dbadmin', :as => 'rails_admin'

  devise_for :users

  root :to => 'page#index'

  get "page/student_view"
  get "page/contributor_view"
  post "page/contributor_view"
  post "page/add_prerequisite"
  
end
