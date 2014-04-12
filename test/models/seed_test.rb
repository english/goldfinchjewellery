require 'test_helper'

class SeedTest < ActiveSupport::TestCase
  # Don't upload images
  def setup
    class << S3::Put
      alias_method :original_call, :call
      def call(arg); 'http://example.com/image.jpg'; end
    end
  end

  def teardown
    class << S3::Put
      undef_method :call
      alias_method :call, :original_call
      undef_method :original_call
    end
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
