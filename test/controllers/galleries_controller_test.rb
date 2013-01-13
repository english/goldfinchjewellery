require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  test "gallery" do
    get :index
    assert_select 'nav li.current a', 'Gallery'
    assert_tag tag: 'img', attributes: { src: /gallery.jpg/ }
  end
end
