Learnopedia::Application.routes.draw do

  mount RailsAdmin::Engine => '/dbadmin', :as => 'rails_admin'

  devise_for :users

  root :to => 'page#index'

  get "page/concept_bundle_interface"
  post "page/concept_bundle_interface"
  
end
