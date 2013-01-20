require 'test_helper'

class NewsTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "add news item" do
    visit '/'
    click_link 'Latest News'
    click_link 'New News Item'

    select 'Events and Exhibitions', from: 'Category'
    fill_in 'Content', with: 'Test news story'
    click_button 'Save and Publish'

    visit '/'
    click_link 'Latest News'
    assert page.has_text? 'Test news story'
  end
end
