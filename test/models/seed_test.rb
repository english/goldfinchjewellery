require 'test_helper'

class SeedTest < ActiveSupport::TestCase
  test "run" do
    image = image_upload_fixture
    S3::Put.stubs(:new).returns(OpenStruct.new(execute: nil, url: 'http://example.com/image.jpg'))

    assert_difference "Jewellery.from_gallery('Birds').count", 6 do
      Seed.run
    end

    begin
      assert Jewellery.from_gallery('Birds').any? { |jewellery| jewellery.description == <<-DESC.chomp }
        Oval Citrine set in 18ct yellow gold, fine silver embossed bird pendant on 18ct yellow gold chain.
      DESC
    rescue => e
      binding.pry
    end
  end
end
