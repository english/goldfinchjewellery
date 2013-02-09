require 'test_helper'

class S3ImageTest < ActiveSupport::TestCase
  test "store! uploads the image" do
    VCR.use_cassette 'S3Image#store!', preserve_exact_body_bytes: true do
      file = Rack::Test::UploadedFile.new('test/fixtures/image.jpg', 'image/jpeg')
      subject = S3Image.new(file)
      subject.store!

      assert_equal 'http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg', subject.url
    end
  end
end
