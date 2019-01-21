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

    # process uploads in background (if enabled)
    if Skrw.process_uploads_in_background_job
      Attacher.promote { |data| Skrw::PromoteJob.perform_async(data) }
      Attacher.delete { |data| Skrw::DeleteJob.perform_async(data) }
    end

    process(:store) do |io, context|
      # expects hash vor multiple versions
      # or a single output for one versions
      # process file dependent on mime-type

      # return io without processing
      output = io

      # process according to mime-type
      mime_type = io.mime_type.split('/')[0]

      if mime_type == 'image' && Skrw.image_processor

        # download and process image
        io.download do |file|
          output = Skrw::Processors::Image.process(file)
        end

      elsif mime_type == 'video' && Skrw.video_processor

        # download and process video
        io.download do |file|
          output = Skrw::Processors::Video.process(file)
        end
      end

      output
    end

    # TODO processing for Video and Audio
    # TODO include processing and move processing to background worker
  end
end