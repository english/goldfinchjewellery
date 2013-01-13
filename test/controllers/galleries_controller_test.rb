require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  test "index" do
    get :index
    assert_select 'nav li.current a', 'Gallery'
    assert_tag tag: 'img', attributes: { src: /gallery.jpg/ }
  end

  test "GET /gallery/peace-doves" do
    get :show, id: 'peace-doves'
    assert_template partial: 'galleries/_peace_doves'
  end

  test "GET /gallery/weather" do
    get :show, id: 'weather'
    assert_template partial: 'galleries/_weather'
  end

  test "GET /gallery/birds" do
    get :show, id: 'birds'
    assert_template partial: 'galleries/_birds'
  end

  test "GET /gallery/commissions" do
    get :show, id: 'commissions'
    assert_template partial: 'galleries/_commissions'
  end

  test "GET /gallery/branches" do
    get :show, id: 'branches'
    assert_template partial: 'galleries/_branches'
  end

  test "GET /gallery/woodlands" do
    get :show, id: 'woodlands'
    assert_template partial: 'galleries/_woodlands'
  end
end
