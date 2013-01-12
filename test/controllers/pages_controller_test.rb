require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "about" do
    get :about
    assert_select 'nav li.current a', 'About'
  end

  test "gallery" do
    get :gallery
    assert_select 'nav li.current a', 'Gallery'
  end

  test "latest news" do
    get :latest_news
    assert_select 'nav li.current a', 'Latest News'
  end

  test "contact" do
    get :contact
    assert_select 'nav li.current a', 'Contact'
  end

  test "links" do
    get :links
    assert_select 'nav li.current a', 'Links'
  end
end
