require 'test_helper'

class JewelleryTest < ActiveSupport::TestCase
  test "#from_gallery" do
    assert_equal [jewelleries(:pidgeon), jewelleries(:robin)], Jewellery.from_gallery('Birds')
    assert_equal [jewelleries(:pidgeon), jewelleries(:robin)], Jewellery.from_gallery('birds')
    assert_equal [jewelleries(:peace_dove)], Jewellery.from_gallery('peace-doves')
    assert_equal [jewelleries(:rain_cloud)], Jewellery.from_gallery('Weather')
  end

  test "saving with an image will upload to S3 and persist its path" do
    jewellery = Jewellery.new(name: 'A jewellery item', description: 'A description of some jewellery', image: image_upload_fixture)

    fake_s3_putter = -> (image) {
      message = "Expected #{image_upload_fixture}, got #{image}"
      raise Minitest::Assertion, message unless image_upload_fixture == image

      "http://example.com/image.jpg"
    }

    stub(jewellery, :s3_putter).to_return(fake_s3_putter)

    jewellery.save!

    assert_equal 'http://example.com/image.jpg', jewellery.image_path
  end

  test "categorised" do
    expected = {
      'Birds'       => [ jewelleries(:robin),
                         jewelleries(:pidgeon) ],
      'Weather'     => [ jewelleries(:rain_cloud) ],
      'Peace Doves' => [ jewelleries(:peace_dove) ],
    }

    assert_equal [ jewelleries(:pidgeon), jewelleries(:robin) ], Jewellery.categorised['Birds']
    assert_equal [ jewelleries(:rain_cloud) ], Jewellery.categorised['Weather']
    assert_equal [ jewelleries(:peace_dove) ], Jewellery.categorised['Peace Doves']
  end
end
