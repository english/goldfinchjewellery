require 'test_helper'

class NewsTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    VCR.configure { |c| c.allow_http_connections_when_no_cassette = true }
  end

  def teardown
    VCR.configure { |c| c.allow_http_connections_when_no_cassette = false }
  end

  test "add news item" do
    visit '/'
    click_link 'Latest News'
    click_link 'New News Item'

    select 'Events & Exhibitions', from: 'Category'
    fill_in 'Content', with: 'Test **news** story'
    attach_file 'Image', 'test/fixtures/image.jpg'
    click_button 'Save and Publish'

    assert page.has_selector?('.success', text: 'News Item saved successfully')

    visit '/'
    click_link 'Latest News'

    assert page.has_text? 'Test news story'
    assert page.has_selector?('.news-item strong', text: 'news'), 'News content should have <strong> element'
    assert_equal 'http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg', page.find('.news-item img')['src']
  end

  test "deletes news item" do
    visit '/'
    click_link 'Latest News'

    assert page.has_content?('In the press')
    within('.press') { click_link 'Delete' }

    assert page.has_selector?('.success', text: 'News Item deleted successfully')

    visit '/'
    click_link 'Latest News'

    refute page.has_content?('In the press')
  end
end
