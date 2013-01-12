require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "about" do
    get :about
    assert_select 'nav li.current a', 'About'
    assert_tag tag: 'img', attributes: { src: /about.jpg/ }
  end

  test "gallery" do
    get :gallery
    assert_select 'nav li.current a', 'Gallery'
    assert_tag tag: 'img', attributes: { src: /gallery.jpg/ }
  end

  test "latest news" do
    get :latest_news
    assert_select 'nav li.current a', 'Latest News'
    assert_tag tag: 'img', attributes: { src: /news.jpg/ }
  end

  test "contact" do
    get :contact
    assert_select 'nav li.current a', 'Contact'
    assert_tag tag: 'img', attributes: { src: /contact.jpg/ }
  end

  test "links" do
    get :links
    assert_select 'nav li.current a', 'Links'
    assert_tag tag: 'img', attributes: { src: /links.jpg/ }
  end
end
