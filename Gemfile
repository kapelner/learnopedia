source 'http://rubygems.org'

gem 'railties', '3.2.0'
gem 'rails', '3.2'

gem 'rake', '0.9.2.2'
gem 'nokogiri', '1.5.0'
gem 'crypt19', :platform => :ruby
gem 'rak'
gem 'POpen4'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem 'devise'
gem 'carrierwave'
gem 'rubystats'

group :production do
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
#  gem "exception_notification", :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"
end

group :development do
  gem 'mysql', :platforms => :mingw
  gem 'win32-open3-19', :platforms => :mingw
  #handy tools to make the console and logging pretty
  gem 'win32console'
  gem 'hirb'
  gem 'wirble'
  gem 'awesome_print'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

#bundle install --without production
