require "test_helper"
require "s3/delete"

class S3DeleteTest < ActiveSupport::TestCase
  test "deletes the image" do
    VCR.use_cassette 'S3Delete#call' do
      S3::Delete.new('http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg').call

      response = Net::HTTP.get_response(URI('http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg'))
      assert_equal '403', response.code
    end
  end
end
