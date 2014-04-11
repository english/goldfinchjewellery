require "test_helper"
require "s3/delete"

class NewsControllerTest < ActionController::TestCase
  def setup
    @valid_news_params = { content: 'Test news item', category: 'Stockists' }
  end

  test ":new sets a new empty News" do
    login
    get :new
    assert_kind_of News, assigns(:news)
    assert assigns(:news).new_record?
  end

  test ":new requires login" do
    get :new
    assert_redirected_to new_session_path
  end

  test ":create creates a new news item" do
    login
    assert_difference 'News.count', 1 do
      post :create, news: @valid_news_params
    end
    assert_redirected_to root_path
  end

  test ":create with invalid post data will redirect to :new with error message" do
    login
    assert_no_difference 'News.count' do
      post :create, news: { foo: 'bar' }
    end
    assert_response 400
    assert_template 'news/new'
    assert_select '.error', "Content: can&#39;t be blank"
    assert_select '.error', "Category: can&#39;t be blank, is not included in the list"
  end

  test ":create uploads an image to S3" do
    login
    image = image_upload_fixture
    S3::Put.expects(:new).with(image).returns(Struct.new(:execute, :url).new)

    post :create, news: @valid_news_params.merge(image: image)
  end

  test ":create with invalid attributes does not upload an image" do
    login
    S3::Put.expects(:new).never
    post :create, news: @valid_news_params.except(:content)

    assert_response 400
  end

  test ":index lists all news items" do
    get :index, format: :json

    json = JSON.parse(response.body)

    assert_equal News.count, json["news"].count
    assert json["news"][0].has_key?("id")
    assert json["news"][0].has_key?("category")
    assert json["news"][0].has_key?("html")
    assert json["news"][0].has_key?("updatedAt")

    assert_equal 4, json["news"][0].keys.count
  end

  test ":index via json allows CORS" do
    get :index, format: :json
    assert_equal "*", response["Access-Control-Allow-Origin"]
  end

  test ":index via html requires login" do
    get :index, format: :html
    assert_redirected_to new_session_path
  end

  test ":destroy deletes news" do
    login

    news = mock('news')
    News.stubs(:find).returns(news)
    news.expects(:destroy)

    delete :destroy, id: 1

    assert_redirected_to root_path
  end

  test ":destroy deletes S3 image" do
    login

    news_item = news(:press)
    news_item.update_attributes(image_path: 'http://example.org/image.jpg')
    News.stubs(:find).returns(news_item)

    S3::Delete.any_instance.expects(:execute)

    delete :destroy, id: 1
  end

  test "cannot destroy without being logged in" do
    delete :destroy, id: news(:press).id
    assert_redirected_to new_session_path
  end

  test "cannot create without being logged in" do
    post :create, news: { content: 'Test news item', category: 'Stockists' }
    assert_redirected_to new_session_path
  end
end
