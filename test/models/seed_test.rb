require 'test_helper'

class SeedTest < ActiveSupport::TestCase
  def setup
    image = image_upload_fixture
    S3::Put.stubs(:new).returns(OpenStruct.new(execute: nil, url: 'http://example.com/image.jpg'))
  end

  def assert_not_empty(subject)
    refute subject.empty?
  end

  test 'creates birds' do
    assert_difference "Jewellery.from_gallery('Birds').count", 6 do
      Seed.run
    end
  end

  test 'uses the description text files' do
    Seed.run
    existing_description = 'Silver acorn with enamel oak leaf pendant.'
    assert_not_empty Jewellery.from_gallery('Woodlands').where(description: existing_description)
  end

  test 'uses the filename as the jewellery name' do
    Seed.run
    existing_name = 'Dragonfly'
    assert_not_empty Jewellery.from_gallery('Commissions').where(name: existing_name)
  end
end
