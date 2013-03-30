require 'test_helper'

class JewelleryTest < ActiveSupport::TestCase
  test "#from_gallery" do
    assert_equal [jewelleries(:pidgeon), jewelleries(:robin)], Jewellery.from_gallery('Birds')
    assert_equal [jewelleries(:pidgeon), jewelleries(:robin)], Jewellery.from_gallery('birds')
    assert_equal [jewelleries(:peace_dove)], Jewellery.from_gallery('peace-doves')
    assert_equal [jewelleries(:rain_cloud)], Jewellery.from_gallery('Weather')
  end
end
