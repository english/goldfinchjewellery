require 'test_helper'

class GalleriesTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    VCR.configure { |c| c.allow_http_connections_when_no_cassette = true }
    Capybara.reset_sessions!
    sign_in
  end

  def teardown
    VCR.configure { |c| c.allow_http_connections_when_no_cassette = false }
  end

  test "creating a gallery entry" do
    visit '/admin'
    click_link 'New Piece of Jewellery'

    fill_in 'Name', with: 'Test Jewellery'
    fill_in 'Description', with: 'Integration test piece of jewellery description'
    select 'Woodlands', from: 'Gallery'
    attach_file 'Image', 'test/fixtures/image.jpg'
    click_button 'Save and Publish'

    visit '/'
    click_link 'Gallery'
    click_link 'Woodlands'
    assert page.has_content? 'Integration test piece of jewellery description'
    assert page.has_selector?('img[alt="Test Jewellery"]')
  end
end
