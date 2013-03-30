require 'test_helper'

class JewelleriesControllerTest < ActionController::TestCase
  def setup
    @valid_jewellery_params = { name: 'Robin', description: 'test description', gallery: 'Birds', image: image_upload_fixture }
    login
  end

  test ":create persists a jewellery item" do
    S3::Put.any_instance.stubs(:execute)

    assert_difference 'Jewellery.count', 1 do
      post :create, jewellery: @valid_jewellery_params
    end

    assert_redirected_to admin_path
  end

  test ":create uploads the image" do
    S3::Put.expects(:new).with(@valid_jewellery_params[:image]).returns(Struct.new(:execute, :url).new)

    post :create, jewellery: @valid_jewellery_params
  end

  test ":create with no image" do
    assert_no_difference 'NewsItem.count' do
      post :create, jewellery: @valid_jewellery_params.except(:image)
    end

    assert_template 'jewelleries/new'
  end

  test ":create with no name" do
    S3::Put.any_instance.stubs(:execute)

    assert_no_difference 'NewsItem.count' do
      post :create, jewellery: @valid_jewellery_params.except(:name)
    end

    assert_template 'jewelleries/new'
  end

  test ":create with no description" do
    S3::Put.any_instance.stubs(:execute)

    assert_no_difference 'NewsItem.count' do
      post :create, jewellery: @valid_jewellery_params.except(:description)
    end

    assert_template 'jewelleries/new'
  end

  test ":create requires being logged in" do
    logout

    S3::Put.any_instance.stubs(:execute)

    assert_no_difference 'NewsItem.count' do
      post :create, jewellery: @valid_jewellery_params
    end

    assert_response 401
  end

  test ":new requires being logged in" do
    logout
    get :new
    assert_response 401
  end
end
