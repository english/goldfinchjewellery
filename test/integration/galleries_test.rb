require 'test_helper'

class GalleriesTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "creating a gallery entry" do
    visit '/'
    click_link 'Gallery'
    click_link 'Peace Doves'
    refute page.has_content? 'Test piece of jewellery description'
    refute page.has_selector?('img[alt="Test Jewellery"]')

    sign_in
    visit '/admin'
    click_link 'New Piece of Jewellery'

    fill_in 'Name', with: 'Test Jewellery'
    fill_in 'Description', with: 'Test piece of jewellery description'
    select 'Peace Doves', from: 'Gallery'
    attach_file 'Image', 'test/fixtures/image.jpg'
    click_button 'Save and Publish'

    visit '/'
    click_link 'Gallery'
    click_link 'Peace Doves'
    assert page.has_content? 'Test piece of jewellery description'
    assert page.has_selector?('img[alt="Test Jewellery"]')
  end
end
