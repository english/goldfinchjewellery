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

  test "saving with an image will upload to S3 and persist its path" do
    image = image_upload_fixture
    S3::Put.expects(:new).with(image).returns(OpenStruct.new(execute: nil, url: 'http://example.com/image.jpg'))

    news_item = NewsItem.create!(content: 'Test news item', category: 'Stockists', image: image)

    assert_equal 'http://example.com/image.jpg', news_item.image_path
  end
end
