require 'test_helper'

class NewsItemsControllerTest < ActionController::TestCase
  test ":new sets a new empty NewsItems" do
    get :new
    assert_kind_of NewsItem, assigns(:news_item)
    assert assigns(:news_item).new_record?
  end
end
