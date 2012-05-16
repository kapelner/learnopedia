Learnopedia::Application.routes.draw do

  mount RailsAdmin::Engine => '/dbadmin', :as => 'rails_admin'

  devise_for :users

  root :to => 'page#index'

  get "page/raw_wikipedia_page"

  
end
