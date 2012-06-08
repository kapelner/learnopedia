source 'http://rubygems.org'

gem 'railties', '3.2.0'
gem 'rails', '3.2'

gem 'rake', '0.9.2.2'
gem 'nokogiri', '1.5.2'
gem 'crypt19', :platform => :ruby
gem 'rak'
gem 'POpen4'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem 'devise'
gem 'cancan'
gem 'carrierwave'
gem 'rubystats'
gem 'paper_trail', :git => 'git://github.com/airblade/paper_trail.git'
gem 'exception_notification', :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"
gem 'sunspot_rails'
gem 'sunspot_solr' #USE from CMD: bundle exec rake sunspot:solr:run
gem 'best_in_place'
gem 'youtube_it', :git => "git://github.com/kylejginavan/youtube_it.git"

group :production do
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
  gem 'whenever', :require => false
  gem 'backup'
end

#my comment

group :development do
  gem 'mysql', :platforms => :mingw
  gem 'win32-open3-19', :platforms => :mingw
  #handy tools to make the console and logging pretty
  gem 'win32console'
  gem 'hirb'
  gem 'wirble'
  gem 'awesome_print'
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git', :require => 'rails_development_boost'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

#bundle install --without production
