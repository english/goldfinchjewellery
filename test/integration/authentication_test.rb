require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "Admin signs in and can edit stuff" do
    visit '/admin'
    refute page.has_content? 'Manage News Items'
    assert page.has_content? 'Log In'

    sign_in

    visit '/admin'
    assert page.has_content? 'Manage News Items'

    click_link 'Sign out'

    visit '/admin'
    refute page.has_content? 'Manage News Items'
    assert page.has_content? 'Log In'
  end
end
