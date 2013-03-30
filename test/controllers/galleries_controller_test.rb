require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  test "index" do
    Gallery.expects(:all_names).returns(%w( this and that ))
    get :index
    assert_tag tag: 'img', attributes: { src: /gallery.jpg/ }
    assert_equal %w( this and that ), assigns(:galleries)
  end

  test "gallery is selected in nav" do
    get :index
    assert_select 'nav li.current a', 'Gallery'

    get :show, id: 'weather'
    assert_select 'nav li.current a', 'Gallery'
  end

  test "GET /gallery/:id asks for jewellery from the gallery" do
    Jewellery.expects(:from_gallery).with('woodlands').returns([jewelleries(:robin)])

    get :show, id: 'woodlands'

    assert_template 'galleries/show'
    assert_equal [jewelleries(:robin)], assigns(:jewelleries)
    assert_select 'p', text: 'Test description'
  end
end
