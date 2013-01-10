require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', 'Lucy Ramsbottom, Jewellery Designer Maker'
    assert_select 'h1', 'Goldfinch Jewellery Designer Maker'
  end
end
