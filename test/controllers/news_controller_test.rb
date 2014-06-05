require "test_helper"
require "s3/delete"

class NewsControllerTest < ActionController::TestCase
  def setup
    @valid_news_params = { content: 'Test news item', category: 'Stockists' }
    @valid_news_params_with_image = @valid_news_params.merge(image: image_upload_fixture)
  end

  def json_body
    @json ||= JSON.parse(response.body)
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

  test ":create uploads an image to S3" do
    login

    S3::Put.expects(:call).with(image_upload_fixture)

    assert_difference 'News.count', 1 do
      post :create, news: @valid_news_params_with_image
    end
  end

  test ":create with invalid attributes does not upload an image" do
    login

    S3::Put.expects(:call).never

    assert_no_difference 'News.count' do
      post :create, news: @valid_news_params_with_image.except(:content)
    end

    assert_response 400
  end

  test ":index lists all news items" do
    get :index, format: :json

    assert_equal "*", response["Access-Control-Allow-Origin"]
    assert_equal News.count, json_body["news"].count
    assert json_body["news"][0].has_key?("id")
    assert json_body["news"][0].has_key?("category")
    assert json_body["news"][0].has_key?("html")
    assert json_body["news"][0].has_key?("updatedAt")

    assert_equal 4, json_body["news"][0].keys.count
  end

  test ":index via html requires login" do
    get :index, format: :html
    assert_redirected_to new_session_path
  end

  test ":destroy deletes S3 image" do
    login

    S3::Delete.expects(:call).with(news(:press).image_path)

    delete :destroy, id: news(:press).id
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
