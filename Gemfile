source "https://rubygems.org"

ruby "2.1.1"

gem "rails", "4.0.3"

gem "sass-rails", "~> 4.0.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 1.2"
gem "bcrypt-ruby", "~> 3.1.2"

gem "newrelic_rpm"
gem "thin"
gem "redcarpet"

group :development, :test do
  gem "sqlite3"
  gem "pry"
end

group :test do
  gem "mocha", "~> 0.13.0", require: false
  gem "vcr"
  gem "webmock", "< 1.9"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
