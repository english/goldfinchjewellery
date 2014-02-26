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
    assert_no_difference 'News.count' do
      post :create, jewellery: @valid_jewellery_params.except(:image)
    end

    assert_response 400
    assert_template 'jewelleries/new'
  end

  test ":create with no name" do
    S3::Put.any_instance.stubs(:execute)

    assert_no_difference 'News.count' do
      post :create, jewellery: @valid_jewellery_params.except(:name)
    end

    assert_response 400
    assert_template 'jewelleries/new'
  end

  test ":create with no description" do
    S3::Put.any_instance.stubs(:execute)

    assert_no_difference 'News.count' do
      post :create, jewellery: @valid_jewellery_params.except(:description)
    end

    assert_response 400
    assert_template 'jewelleries/new'
  end

  test ":create with invalid attributes does not upload an image" do
    S3::Put.expects(:new).never
    post :create, jewellery: @valid_jewellery_params.except(:description)

    assert_response 400
  end

  test ":create requires being logged in" do
    logout

    S3::Put.any_instance.stubs(:execute)

    assert_no_difference 'News.count' do
      post :create, jewellery: @valid_jewellery_params
    end

    assert_response 401
  end

  test ":new requires being logged in" do
    logout
    get :new
    assert_response 401
  end

  test ":destroy deletes a jewellery item" do
    assert_difference 'Jewellery.count', -1 do
      delete :destroy, id: jewelleries(:robin).id
    end
  end

  test ":destroy redirects to admin page" do
    delete :destroy, id: jewelleries(:robin).id
    assert_redirected_to admin_path
  end

  test ":edit renders form for jewellery item" do
    get :edit, id: jewelleries(:robin).id
    assert_equal jewelleries(:robin), assigns(:jewellery)
    assert_select 'input#jewellery_description[value=?]', jewelleries(:robin).description
  end

  test ":update updates a jewellery item" do
    robin = jewelleries(:robin)
    put :update, id: robin.id, jewellery: { name: 'new name', description: 'new description' }

    robin.reload
    assert_equal 'new name', robin.name
    assert_equal 'new description', robin.description

    assert_redirected_to admin_path
  end

  test ":update with invalid params" do
    robin = jewelleries(:robin)
    put :update, id: robin.id, jewellery: { name: '', description: 'new description' }

    robin.reload
    refute_equal 'new description', robin.description
    assert_template 'jewelleries/edit'
  end
end
