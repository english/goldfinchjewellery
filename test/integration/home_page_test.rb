require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  test "home page" do
    get '/'
    assert_template 'pages/index'
  end
end
