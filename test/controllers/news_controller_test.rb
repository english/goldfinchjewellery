require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  test ":new sets a new empty NewsItem" do
    get :new
    assert_kind_of NewsItem, assigns(:news_item)
    assert assigns(:news_item).new_record?
  end

  test ":create creates a new news item" do
    assert_difference 'NewsItem.count', 1 do
      post :create, news_item: { content: 'Test news item', category: 'Stockists' }
    end
    assert_redirected_to news_index_path
  end

  test ":create with invalid post data will redirect to :new with error message" do
    assert_no_difference 'NewsItem.count' do
      post :create, news_item: { foo: 'bar' }
    end
    assert_template 'news/new'
    assert_select '.error', "Content: can&#39;t be blank"
    assert_select '.error', "Category: can&#39;t be blank, is not included in the list"
  end

  test ":create uploads an image to S3" do
    image = fixture_file_upload '/image.jpg', 'image/jpeg'
    S3Image.any_instance.expects(:store!)

    post :create, news_item: { image: image, content: 'Test content', category: 'Stockists' }
    assert_equal 'http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/image.jpg', NewsItem.last.image_path
  end

  test ":index lists all news items" do
    get :index
    assert_select '.news-items .news-category.events-and-exhibitions .news-item .content', 'Craftsmanship and Design Awards 2011'
    assert_select '.news-items .news-category.stockists .news-item .content', 'New stockist at Red Barn Gallery, Milnthorpe'
  end

  test ":index sets Latest News as active" do
    get :index
    assert_select 'nav li.current a', 'Latest News'
  end

  test ":index uses news image for title" do
    get :index
    assert_tag tag: 'img', attributes: { src: /news.jpg/ }
  end

  test ":destroy deletes news_item" do
    news_item = mock('news_item')
    NewsItem.stubs(:find).returns(news_item)
    news_item.expects(:destroy)

    delete :destroy, id: 1
  end

  test ":destroy deletes S3 image" do
    news_item = news_items(:press)
    news_item.update_attributes(image_path: 'http://example.org/image.jpg')
    NewsItem.stubs(:find).returns(news_item)

    S3Delete.any_instance.expects(:execute)

    delete :destroy, id: 1
  end
end
