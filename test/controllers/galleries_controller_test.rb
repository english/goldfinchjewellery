require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  PAGES = %w[weather peace-doves birds commissions woodlands]

  test "index" do
    get :index
    assert_tag tag: 'img', attributes: { src: /gallery.jpg/ }
  end

  test "gallery is selected in nav" do
    get :index
    assert_select 'nav li.current a', 'Gallery'

    PAGES.each do |page|
      get :show, id: page
      assert_select 'nav li.current a', 'Gallery'
    end
  end

  test "GET /gallery/:id renders correct partial" do
    PAGES.each do |page|
      get :show, id: page
      assert_template partial: "galleries/_#{page.underscore}"
    end
  end
end
