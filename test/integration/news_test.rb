require 'test_helper'

class NewsTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

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
    assert page.has_selector?('article strong', text: 'news'), 'News content should have <strong> element'
    assert_equal page.find('article img')['src'], %r{^http://s3\.amazonaws\.com.+image\.jpg$}
  end
end
