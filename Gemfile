source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails',     github: 'rails/rails'
gem 'arel',      github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'sass-rails',   github: 'rails/sass-rails'
gem 'puma'
gem 'redcarpet'
gem 'bcrypt-ruby'
gem 'newrelic_rpm', github: 'newrelic/rpm'

group :assets do
  gem 'sprockets', github: 'jamienglish/sprockets'
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'turn'
  gem 'capybara', '~> 2.0'
  gem 'poltergeist', github: 'jonleighton/poltergeist', require: 'capybara/poltergeist'
  gem 'mocha', '~> 0.13.0', require: false
  gem 'vcr'
  gem 'webmock', '< 1.9'
end

gem 'pry', group: [:development, :test]
