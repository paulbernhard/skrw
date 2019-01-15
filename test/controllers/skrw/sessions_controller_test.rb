require 'test_helper'

module Skrw
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Devise::Test::IntegrationHelpers

    setup do
      @user = skrw_users(:user)
    end

    test 'get new is success' do
      get skrw.new_user_session_url
      assert_response :success
    end

    test 'post create with valid params is success' do
      post skrw.user_session_url, params: { user: { email: @user.email, password: 'password' } }
      assert_redirected_to '/'
    end

    test 'post create with invalid params is success' do
      sign_in(@user)
      delete skrw.destroy_user_session_url
      assert_redirected_to '/'
    end
  end
end