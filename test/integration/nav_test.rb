require 'test_helper'

class NavTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def page_title
    first('title').native.text
  end

  test "navigating around the site" do
    visit '/'
    assert_equal 'Lucy Ramsbottom, Jewellery Designer Maker', page_title

    click_link 'Gallery'
    assert_equal 'Gallery', page_title

    click_link 'Latest News'
    assert_equal 'Latest News', page_title

    click_link 'Contact'
    assert_equal 'Contact Me', page_title

    click_link 'Links'
    assert_equal 'Links', page_title
  end
end
