require 'test_helper'

class GalleryTest < ActiveSupport::TestCase
  test '#all_names' do
    assert_equal ['Peace Doves', 'Weather', 'Birds', 'Commissions', 'Branches', 'Woodlands'], Gallery.all_names
  end
end
