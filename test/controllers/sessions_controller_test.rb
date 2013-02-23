require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  fixtures :users

  test "sign in successfully" do
    post :create, email: users(:someone).email, password: 'secret'
    assert_redirected_to root_path
    assert_equal users(:someone).id, session[:user_id]
    assert_equal 'Signed in successfully', flash.notice
  end

  test "sign in with invalid password" do
    post :create, email: users(:someone).email, password: 'invalid'
    assert_template 'sessions/new'
    refute session[:user_id]
    assert_equal 'Invalid email or password', flash.alert
  end

  test "sign out" do
    session[:user_id] = users(:someone).id
    delete :destroy, id: 'current'
    assert_nil session[:user_id]
    assert_redirected_to root_path
    assert_equal 'Signed out successfully', flash.notice
  end
end
