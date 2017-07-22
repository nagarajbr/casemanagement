source 'http://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.11'
# Use postgresql as the database for Active Record
gem 'pg' 
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
gem 'nokogiri', '>=1.6.2'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin]
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
#gem 'scrypt'
#gem 'authlogic'
 gem 'zurb-foundation'
#gem 'foundation-rails', '~> 5.3.1'
gem 'foundation-icons-sass-rails','~> 3.0.0'
gem 'pundit'
gem 'simple-navigation'

group :development, :test do
	gem 'hirb'
end

group :development, :test do
  gem "rspec-rails"    # includes RSpec with some extra Rails-specific features
  gem 'factory_girl_rails' #replaces Rails. default fixtures for feeding test data to the test suite with much more preferable factories.
  gem "capybara" # programmatically simulates your users. web interactions.
  gem 'database_cleaner'
  gem 'launchy' #opens your default web browser upon failed integration specs to show you what your application is rendering
  gem 'faker' #generates place holders for factories


  #gem 'metric_fu'
  #gem 'rcov', '0.9.11'
  #gem 'simplecov'
  #gem 'simplecov-rcov-text'
  #gem 'cane'
  #gem 'rails_best_practices'
  #gem 'churn'
  #gem 'reek'
  #gem 'roodi'

  gem 'state_machine'
  gem 'graphviz'
  gem 'ruby-graphviz', :require => 'graphviz' # Optional: only required for graphing

end

 gem 'execjs'
 gem 'therubyracer', :platforms => :ruby
 gem 'reform', '2.2.2'
 gem 'reform-rails'
 #gem 'resque'

  # Manoj Pagination Gem - 10/28/2014
 gem 'kaminari'
 gem 'pdf-forms', '0.5.8'
 gem "combined_time_select", "~> 1.0.1"
 gem "gmaps4rails","~> 2.1.2"
 #gem "underscore-rails", "~>1.7.0"
 gem 'state_machines'
 gem 'state_machines-activerecord'
 gem 'state_machines-audit_trail'
 gem 'state_machines-graphviz' , group: :development
 gem 'paper_trail', '~> 3.0.1'
 #gem 'dashing-rails'
 gem 'puma'
 if ENV['SSO_DEV']
  gem 'gds-sso', path: '../gds-sso'
 else
  gem 'gds-sso', '9.3.0'
 end
 gem 'cancan', '1.6.10'
 gem 'httparty'
