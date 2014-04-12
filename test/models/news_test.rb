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

  test "saving with an image will upload to S3 and persist its path" do
    news_item = News.new(content: 'Test news item', category: 'Stockists', image: image_upload_fixture)

    stub(news_item, :s3_putter) do |image|
      message = "Expected #{image_upload_fixture}, got #{image}"
      raise Minitest::Assertion, message unless image_upload_fixture == image

      -> { "http://example.com/image.jpg" }
    end

    news_item.save!

    assert_equal "http://example.com/image.jpg", news_item.image_path
  end
end
