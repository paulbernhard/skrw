# include this module for model testing when using
# your own Upload model with Skrw::Concerns::Uploadable

module Skrw::Concerns::UploadTest
  extend ActiveSupport::Concern

  included do

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