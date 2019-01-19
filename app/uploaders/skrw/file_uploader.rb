module Skrw
  class FileUploader < Shrine    
    # assign file mime_type to record file_mime_type field
    plugin :metadata_attributes, :mime_type => :mime_type
  end
end