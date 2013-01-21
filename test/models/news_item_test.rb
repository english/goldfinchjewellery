require 'test_helper'

class NewsItemTest < ActiveSupport::TestCase
  test "Categorised News Items" do
    groups = NewsItem.categorised
    assert groups.has_key? 'Awards'
    assert groups.has_key? 'Press'
    assert_equal 2, groups['Events & Exhibitions'].count
  end
end
