require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:micheal)
  end
  test "Layout Links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', edit_user_path(@user), count: 0
    assert_select 'a[href=?]', users_path, count: 0
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path, text: 'Log out', method: :destroy
    assert_select 'a[href=?]', user_path(@user), text: 'Profile'
    assert_select 'a[href=?]', edit_user_path(@user), text: 'Settings', method: :patch
    assert_select 'a[href=?]', users_path
    get signup_path
    assert_select "title", full_title("Sign up")
    assert_template 'users/new'
    get login_path
    assert_template 'sessions/new'
  end
  
end
