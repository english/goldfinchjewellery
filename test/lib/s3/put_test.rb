require "test_helper"
require "s3/put"

class S3::PutTest < ActiveSupport::TestCase
  test "uploads the image" do
    VCR.use_cassette 'S3Image#call', preserve_exact_body_bytes: true do
      file = Rack::Test::UploadedFile.new('test/fixtures/image.jpg', 'image/jpeg')
      subject = S3::Put.new(file)
      url = subject.call

      assert_equal 'http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg', url
      response = Net::HTTP.get_response(URI('http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg'))
      assert_equal '200', response.code
    end
  end
end
