module Skrw
  class Upload < ApplicationRecord
    belongs_to :uploadable, polymorphic: true
    include Skrw::FileUploader::Attachment.new(:file)
  end
end
