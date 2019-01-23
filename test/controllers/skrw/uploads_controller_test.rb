require 'test_helper'

module Skrw
  class UploadsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Devise::Test::IntegrationHelpers

    setup do
      @user = skrw_users(:user)
      @image_path = File.join(Rails.root, 'test/files', 'image.jpg')
    end

    test 'create upload' do
      sign_in(@user)
      assert_difference('Upload.count', 1) do
        post skrw.uploads_url, params: { upload: { file: Rack::Test::UploadedFile.new(@image_path, 'image/jpeg') } }, xhr: true
      end
    end

    test 'create upload without file fails' do
      sign_in(@user)
      assert_no_difference('Upload.count', 1) do
        post skrw.uploads_url, params: { upload: { file: nil } }, xhr: true
      end

      assert_response :unprocessable_entity
    end

    test 'create upload without login requires authentication' do
      assert_no_difference('Upload.count') do
        post skrw.uploads_url, params: { upload: { file: Rack::Test::UploadedFile.new(@image_path, 'image/jpeg') } }, xhr: true
      end

      assert_response :unauthorized
    end

    test 'destroys upload' do
      @upload = Skrw::Upload.new
      @upload.save(validate: false)
      @upload.reload

      sign_in(@user)
      assert_difference('Upload.count', -1) do
        delete upload_url(@upload), xhr: true
      end
    end

    test 'destroy upload without login requires authentication' do
      @upload = Skrw::Upload.new
      @upload.save(validate: false)
      @upload.reload
      
      assert_no_difference('Upload.count') do
        delete upload_url(@upload), xhr: true
      end

      assert_response :unauthorized
    end
  end
end
