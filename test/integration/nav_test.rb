require 'test_helper'

class NavTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "navigating around the site" do
    visit '/'
    assert page.has_selector?('title', text: 'Lucy Ramsbottom, Jewellery Designer Maker')

    click_link 'Gallery'
    assert page.has_selector?('title', text: 'Gallery')

    click_link 'Latest News'
    assert page.has_selector?('title', text: 'Latest News')

    click_link 'Contact'
    assert page.has_selector?('title', text: 'Contact Me')

    click_link 'Links'
    assert page.has_selector?('title', text: 'Links')
  end
end
