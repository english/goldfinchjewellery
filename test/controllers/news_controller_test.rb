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

  test ":create uploads an image to S3" do
    login

    called = false
    fake_s3_putter = -> (image) {
      assert_equal image_upload_fixture, image
      called = true
    }

    stub(@controller, :s3_putter).to_return(fake_s3_putter)

    assert_difference 'News.count', 1 do
      post :create, news: @valid_news_params.merge(image: image_upload_fixture)
    end

    assert called
  end

  test ":create with invalid attributes does not upload an image" do
    login

    def @controller.s3_putter
      raise "I should not have been called"
    end

    assert_no_difference 'News.count' do
      post :create, news: @valid_news_params.except(:content)
    end

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

  test ":destroy deletes S3 image" do
    login

    news_item = news(:press)
    news_item.update_attributes!(image_path: 'http://example.org/image.jpg')

    called = false
    fake_deleter = -> (path) {
      called = true
      assert_equal 'http://example.org/image.jpg', path
    }
    stub(@controller, :s3_deleter).to_return(fake_deleter)

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
