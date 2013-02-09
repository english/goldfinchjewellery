require 'test_helper'

class S3imageTest < ActiveSupport::TestCase
  test "store! uploads the image" do
    VCR.use_cassette 'S3image#store!', preserve_exact_body_bytes: true do
      subject = S3image.new Rack::Test::UploadedFile.new('test/fixtures/image.jpg', 'image/jpeg')
      subject.store!

      assert_equal 'http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg', subject.url
    end
  end
end
