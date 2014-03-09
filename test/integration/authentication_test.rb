require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "Admin signs in and can edit stuff" do
    get_via_redirect "/"

    assert_equal "/sessions/new", path
    assert_select "body", text: /Log In/

    post_via_redirect "/sessions", email: "someone@example.org", password: "secret"
    assert_response :success
    assert_equal "/news", path
    assert_select "a[href=/jewellery]", text: "Manage Jewellery"
    assert_select "a", text: "New News Item"

    get "/jewellery"
    assert_select "a[href=/news]", text: "Manage News"
    assert_select "a", text: "New Jewellery Item"

    delete_via_redirect "/sessions/current"

    get "/news"
    assert_response :redirect
    get "/jewellery"
    assert_response :redirect
  end
end
