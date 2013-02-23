require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.reset_sessions!
  end

  test "Admin signs in and can edit stuff" do
    visit '/'
    click_link 'Latest News'
    refute page.has_link?('Delete'), 'Page should not have any Delete links'
    refute page.has_link?('New News Item'), 'Page should not have a New News Item link'

    sign_in
    assert page.has_selector?('.success', text: 'Signed in successfully')

    visit '/'
    click_link 'Latest News'
    assert page.has_link?('Delete')
    assert page.has_link?('New News Item')
  end

  test "Admin can sign in and then sign out" do
    sign_in

    click_link 'Latest News'
    assert page.has_link?('Delete')

    click_link 'Sign out'
    click_link 'Latest News'
    refute page.has_link?('Delete')
  end

  def sign_in
    visit '/sign_in'
    fill_in 'Email', with: 'someone@example.org'
    fill_in 'Password', with: 'secret'
    click_button 'Sign in'
  end
end
