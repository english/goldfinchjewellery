require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "Admin signs in and can edit stuff" do
    get_via_redirect "/"

    assert_equal "/sessions/new", path
    assert_select "body", text: /Log In/
    post_via_redirect "/sessions", email: "someone@example.org", password: "secret"

    assert_response :success
    assert_equal "/news", path
    assert_select "a", text: "New News Item"
    delete_via_redirect "/sessions/current"

    get "/news"
    assert_response :redirect
  end
end
