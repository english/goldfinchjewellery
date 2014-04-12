ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def image_upload_fixture
    path = File.join(ActionController::TestCase.fixture_path, '/image.jpg')
    @image_upload_fixture ||= Rack::Test::UploadedFile.new(path, 'image/jpeg')
  end

  def login
    session[:user_id] = users(:someone).id
  end

  def logout
    session[:user_id] = nil
  end

  def stub(object, method_name)
    Object.new.tap do |mock|
      mock.define_singleton_method(:to_return) do |return_value|
        object.define_singleton_method(method_name) do
          return_value
        end
      end
    end
  end
end
