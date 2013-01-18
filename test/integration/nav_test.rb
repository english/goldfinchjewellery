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

  test "navigating the gallery" do
    visit '/'
    click_link 'Gallery'

    click_link 'Peace Doves'
    assert_equal 'Peace Doves | Gallery', page_title

    click_link 'Back to gallery'
    click_link 'Weather'
    assert_equal 'Weather | Gallery', page_title

    click_link 'Back to gallery'
    click_link 'Birds'
    assert_equal 'Birds | Gallery', page_title

    click_link 'Back to gallery'
    click_link 'Commissions'
    assert_equal 'Commissions | Gallery', page_title

    click_link 'Back to gallery'
    click_link 'Branches'
    assert_equal 'Branches | Gallery', page_title

    click_link 'Back to gallery'
    click_link 'Woodlands'
    assert_equal 'Woodlands | Gallery', page_title
  end
end
