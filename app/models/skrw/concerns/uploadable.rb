# Uploadable can be hooked into a model responsible for file uploads
# required fields are file_data:json, file_mime_type:string, promoted:boolean

module Skrw::Concerns::Uploadable
  extend ActiveSupport::Concern

  included do
    # hook shrine FileUploader
    include Skrw::FileUploader::Attachment.new(:file)

    # update processed field
    before_save :update_promoted

    # scopes
    scope :images, -> { where(file_type: 'image') }
    scope :videos, -> { where(file_type: 'video') }

    # validate presence of file
    validates :file, presence: true
  end

  def file_type
    self.file_mime_type.split('/')[0]
  end

  private

    def update_promoted
      if file_data_changed? && file_attacher.cached?
        self.promoted = false
      elsif file_data_changed? && file_attacher.stored?
        self.promoted = true
      end
    end
end