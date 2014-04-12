require "test_helper"
require "s3/put"

class JewelleryControllerTest < ActionController::TestCase
  def setup
    @valid_jewellery_params = { name: 'Robin', description: 'test description', gallery: 'Birds', image: image_upload_fixture }
    S3::Put.any_instance.stubs(:call)
  end

  test ":index via json allows CORS" do
    get :index, format: :json
    assert_equal "*", response["Access-Control-Allow-Origin"]
  end

  test ":index via json" do
    get :index, format: :json
    assert_response :success

    json = JSON.parse(response.body)

    assert_equal %w( jewellery ), json.keys

    expected_keys = %w( id name description gallery image_path created_at updated_at )
    assert_equal expected_keys.sort, json["jewellery"][0].keys.sort
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

    assert_difference "Jewellery.count", -1 do
      delete :destroy, id: Jewellery.last.id
    end
  end

  test ":create persists a jewellery item" do
    session[:user_id] = users(:someone).id

    assert_difference 'Jewellery.count', 1 do
      post :create, jewellery: @valid_jewellery_params
    end

    assert_redirected_to jewellery_index_path
  end

  test ":create with missing params" do
    session[:user_id] = users(:someone).id

    assert_no_difference 'Jewellery.count' do
      post :create, jewellery: @valid_jewellery_params.except(:name)
    end

    assert_template 'jewellery/new'
  end

  test ":create with invalid attributes does not upload an image" do
    session[:user_id] = users(:someone).id
    S3::Put.expects(:new).never
    post :create, jewellery: @valid_jewellery_params.except(:description)
  end
end
