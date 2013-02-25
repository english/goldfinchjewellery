require 'test_helper'

class S3DeleteTest < ActiveSupport::TestCase
  test "delete! deletes the image" do
    VCR.use_cassette 'S3Delete#execute' do
      S3Delete.new('http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg').execute

      response = Net::HTTP.get_response(URI('http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg'))
      assert_equal '403', response.code
    end
  end
end
