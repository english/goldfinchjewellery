ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'turn/autorun'

Turn.config.natural = true

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def sign_in
    visit '/admin'
    fill_in 'Email', with: 'someone@example.org'
    fill_in 'Password', with: 'secret'
    click_button 'Sign in'
  end

  def image_upload_fixture
    Rack::Test::UploadedFile.new(File.join(ActionController::TestCase.fixture_path, '/image.jpg'), 'image/jpeg')
  end

  def login
    session[:user_id] = users(:someone).id
  end

  def logout
    session[:user_id] = nil
  end
end
