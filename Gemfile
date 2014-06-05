source "https://rubygems.org"

ruby "2.1.1"

gem "rails", "~> 4.1.0"

gem "sass-rails", "~> 4.0.0"
gem "bootstrap-sass", "~> 3.1.1"
gem "sprockets-rails"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "bcrypt-ruby", "~> 3.1.2"

gem "newrelic_rpm"
gem "skylight"
gem "thin"
gem "redcarpet"

gem "s3", github: "jamienglish/s3"

gem "mocha", group: :test, require: false

group :development, :test do
  gem "sqlite3"
  gem "pry"
  gem "spring"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
