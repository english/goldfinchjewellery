require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def assert_current(actual)
    assert_equal({ class: 'current' }, actual)
  end

  def fullpath=(fullpath)
    self.stubs(:request).returns(stub_everything(fullpath: fullpath))
  end

  test "list_item_options_for 'About'" do
    self.fullpath = '/'
    assert_current list_item_options_for("About", root_path)

    self.fullpath = '/news/new'
    assert_nil list_item_options_for("About", root_path)
  end

  test "list_item_options_for 'Latest News'" do
    self.fullpath = '/news'
    assert_current list_item_options_for("Latest News", news_index_path)

    self.fullpath = '/news/new'
    assert_nil list_item_options_for("Latest News", news_index_path)
  end

  test "list_item_options_for 'Gallery'" do
    self.fullpath = '/galleries'
    assert_current list_item_options_for("Gallery", galleries_path)

    self.fullpath = '/galleries/weather'
    assert_current list_item_options_for("Gallery", galleries_path)

    self.fullpath = '/links'
    assert_nil list_item_options_for("Gallery", galleries_path)
  end
end
