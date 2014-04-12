require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  test "Categorised News Items" do
    groups = News.categorised
    assert groups.has_key? 'Awards'
    assert groups.has_key? 'Press'
    assert_equal 2, groups['Events & Exhibitions'].count
  end

  test "Last Updated" do
    News.delete_all

    newest = News.create!(content: 'Cache test', updated_at: Date.tomorrow, category: 'Press')
    oldest = News.create!(content: 'Cache test', updated_at: Date.yesterday, category: 'Press')

    assert_equal newest, News.last_updated
  end
end
