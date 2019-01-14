require 'test_helper'

module Skrw
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Devise::Test::IntegrationHelpers

    setup do 
      @user = skrw_users(:user)
      @admin = skrw_users(:admin)
    end

    test 'get index as user is success' do
      sign_in(@user)
      get users_url
      assert_response :success
    end

    test 'get index requires authentication' do
      get users_url
      assert_redirected_to skrw.new_user_session_url
    end

    test 'get edit as correct user is success' do
      sign_in(@user)
      get edit_user_url(@user)
      assert_response :success
    end

    test 'get edit as wrong user requires authentication' do
      sign_in(@user)
      get edit_user_url(@admin)
      assert_redirected_to skrw.new_user_session_url
    end

    test 'get edit requires authentication' do
      get edit_user_url(@user)
      assert_redirected_to skrw.new_user_session_url
    end

    test 'update as correct user is success' do
      email = "anotherbody@hollywood.com"
      sign_in(@user)
      patch user_url(@user, user: { email: email })
      assert_equal email, @user.reload.email
      assert_redirected_to skrw.users_url
    end

    test 'update as correct user with invalid params fails' do
      email = @admin.email
      sign_in(@user)
      patch user_url(@user, user: { email: email })
      assert_not_equal email, @user.reload.email
    end

    test 'update as wrong user requires authentication' do
      sign_in(@user)
      patch user_url(@admin)
      assert_redirected_to skrw.new_user_session_url
    end

    test 'update requires authentication' do
      patch user_url(@admin)
      assert_redirected_to skrw.new_user_session_url
    end

    test 'destroy other user as admin is success' do
      sign_in(@admin)
      assert_difference('User.count', -1) do
        delete user_url(@user)
      end
      assert_redirected_to skrw.users_url
    end

    test 'destroy current user fails' do
      sign_in(@admin)
      assert_no_difference('User.count') do
        delete user_url(@admin)
      end
      assert_redirected_to skrw.new_user_session_url
    end

    test 'destroy user requires authentication' do
      assert_no_difference('User.count') do
        delete user_url(@admin)
      end
      assert_redirected_to skrw.new_user_session_url
    end
  end
end
