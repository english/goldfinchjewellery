require "test_helper"
require "s3/put"

class JewelleryControllerTest < ActionController::TestCase
  def setup
    @valid_jewellery_params = {
      name: 'Robin', description: 'test description', gallery: 'Birds', image: image_upload_fixture
    }
  end

  def json_body
    JSON.parse(response.body)
  end

  test ":index via json" do
    get :index, format: :json
    assert_response :success

    assert_equal "*", response["Access-Control-Allow-Origin"]
    assert_equal %w( jewellery ), json_body.keys
    assert_equal %w( id name description gallery image_path created_at updated_at ).sort,
                 json_body["jewellery"].first.keys.sort
  end

  test ":index requires login" do
    get :index
    assert_redirected_to new_session_path
  end

  test ":destroy requires login" do
    assert_no_difference "Jewellery.count" do
      delete :destroy, id: Jewellery.last.id
    end

    assert_redirected_to new_session_path
  end

  test ":destroy deletes" do
    session[:user_id] = users(:someone).id
    jewellery = Jewellery.last

    S3::Delete.expects(:call).with(jewellery.image_path)

    assert_difference "Jewellery.count", -1 do
      delete :destroy, id: jewellery.id
    end
  end

  test ":create persists a jewellery item" do
    session[:user_id] = users(:someone).id

    S3::Put.expects(:call).with(image_upload_fixture)

    assert_difference 'Jewellery.count', 1 do
      post :create, jewellery: @valid_jewellery_params
    end

    assert_redirected_to jewellery_index_path
  end

  test ":create with missing params" do
    session[:user_id] = users(:someone).id

    S3::Put.expects(:call).never

    assert_no_difference 'Jewellery.count' do
      post :create, jewellery: @valid_jewellery_params.except(:name)
    end

    assert_template 'jewellery/new'
  end

  test ":create with invalid attributes does not upload an image" do
    session[:user_id] = users(:someone).id

    S3::Put.expects(:call).never

    post :create, jewellery: @valid_jewellery_params.except(:description)
  end
end
