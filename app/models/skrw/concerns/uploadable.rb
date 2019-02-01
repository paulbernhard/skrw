# Uploadable can be hooked into a model responsible for file uploads
# required fields are file_data:json, file_mime_type:string, promoted:boolean

module Skrw::Concerns::Uploadable
  extend ActiveSupport::Concern

  included do
    # hook shrine FileUploader
    include Skrw::FileUploader::Attachment.new(:file)

    # update processed field
    before_save :update_promoted, :update_mime_type

    # scopes
    scope :images, -> { where(file_type: 'image') }
    scope :videos, -> { where(file_type: 'video') }

    # validate presence of file
    validates :file, presence: true
  end

  def file_type
    self.file_mime_type.split('/')[0] if self.file
  end

  def file_url(version: nil)
    if self.file.is_a?(Hash)
      return version.nil? ? self.file.values.first.url : self.file[version].url
    else
      return self.file.url
    end
  end

  private

    # update promotion state after upload is stored
    def update_promoted
      if file_data_changed? && file_attacher.cached?
        self.promoted = false
      elsif file_data_changed? && file_attacher.stored?
        self.promoted = true
      end
    end

    # update file_mime_type with metadata from
    # file or first version in file hash
    def update_mime_type
      if file_data_changed?
        metadata = self.file.is_a?(Hash) ? self.file.values.first.metadata : self.file.metadata
        self.file_mime_type = metadata['mime_type']
      end
    end
end