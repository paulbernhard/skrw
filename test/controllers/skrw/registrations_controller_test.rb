# require 'test_helper'

# module Skrw
#   class RegistrationsControllerTest < ActionDispatch::IntegrationTest
#     include Engine.routes.url_helpers
#     include Devise::Test::IntegrationHelpers

#     setup do
#       # @routes = Engine.routes
#       @user = skrw_users(:user)
#       @admin = skrw_users(:admin)
#     end

#     # TODO test authentication of registration access

#     # test 'get signup without login' do
#     #   skip
#     #   get new_user_registration_url
#     #   assert_redirected_to new_user_session_url
#     # end

#     test 'get signup with user login' do
#       get new_user_registration_url
#       assert_redirected_to new_user_session_url
#     end 

#     test 'get signup with admin login' do
#       sign_in(@user)
#       get new_user_registration_url
#       assert_response :success
#     end   
#   end
# end