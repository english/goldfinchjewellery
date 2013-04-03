require 'test_helper'

class JewelleryTest < ActiveSupport::TestCase
  test "#from_gallery" do
    assert_equal [jewelleries(:pidgeon), jewelleries(:robin)], Jewellery.from_gallery('Birds')
    assert_equal [jewelleries(:pidgeon), jewelleries(:robin)], Jewellery.from_gallery('birds')
    assert_equal [jewelleries(:peace_dove)], Jewellery.from_gallery('peace-doves')
    assert_equal [jewelleries(:rain_cloud)], Jewellery.from_gallery('Weather')
  end

  test "saving with an image will upload to S3 and persist its path" do
    image = image_upload_fixture
    S3::Put.expects(:new).with(image).returns(OpenStruct.new(execute: nil, url: 'http://example.com/image.jpg'))

    jewellery = Jewellery.create!(name: 'A jewellery item', description: 'A description of some jewellery', image: image)

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
