require 'test_helper'

class NewsItemTest < ActiveSupport::TestCase
  test "Categorised News Items" do
    groups = NewsItem.categorised
    assert groups.has_key? 'Awards'
    assert groups.has_key? 'Press'
    assert_equal 2, groups['Events & Exhibitions'].count
  end

  test "Last Updated" do
    NewsItem.delete_all

    newest = NewsItem.create!(content: 'Cache test', updated_at: Date.tomorrow, category: 'Press')
    oldest = NewsItem.create!(content: 'Cache test', updated_at: Date.yesterday, category: 'Press')

    assert_equal newest, NewsItem.last_updated
  end
end
