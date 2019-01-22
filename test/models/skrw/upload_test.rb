require 'test_helper'

module Skrw
  class UploadTest < ActiveSupport::TestCase

    setup do
      @upload = Skrw::Upload.new
      @image_path = File.join(Rails.root, 'test/files', 'image.jpg')
    end
    
    test 'is valid' do
      @upload.file = File.open(@image_path)
      assert @upload.valid?
    end

    test 'is invalid without file' do
      assert_not @upload.valid?
    end

    test 'sets mime and file types' do
      @upload.file = File.open(@image_path)
      @upload.save
      @upload.reload
      assert_match /^image\/.+$/, @upload.file_mime_type, "string starts with 'image/'"
      assert_equal 'image', @upload.file_type
    end

    test 'updates promoted after storing file' do
      @upload.file = File.open(@image_path)
      @upload.save
      assert @upload.reload.promoted
    end
  end
end
