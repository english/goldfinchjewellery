require 'test_helper'

class S3imageTest < ActiveSupport::TestCase
  test "store! uploads the image" do
    subject = S3image.new Rack::Test::UploadedFile.new('test/fixtures/image.jpg', 'image/jpeg')
    subject.store!

    assert_match %r{^http://s3-eu-west-1\.amazonaws\.com.+image\.jpg$}, subject.url
  end
end
