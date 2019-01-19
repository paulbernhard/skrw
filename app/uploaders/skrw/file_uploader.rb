# use libvips library for image processing
require 'image_processing/vips'

module Skrw
  class FileUploader < Shrine    
    # assign file mime_type to record file_mime_type field
    plugin :metadata_attributes, :mime_type => :mime_type
    
    # validate file uploads
    plugin :validation_helpers, default_messages: {
      mime_type_inclusion: -> (whitelist) { I18n.t('shrine.errors.mime_type', whitelist: whitelist.join(', ')) },
      max_size: -> (max) { I18n.t('shrine.errors.max_size', max: max / 1048576.0) }
    }

    Attacher.validate do
      validate_mime_type_inclusion Skrw.allowed_upload_mime_types
      validate_max_size Skrw.max_upload_file_size
    end

    # move promotion / deletion to background job
    Attacher.promote { |data| Skrw::PromoteJob.perform_async(data) }
    Attacher.delete { |data| Skrw::DeleteJob.perform_async(data) }

    # TODO include processing and move processing to background worker
  end
end