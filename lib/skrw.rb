require 'skrw/engine'
require 'devise'

module Skrw

  # set config variables with defaults
  class << self
    # set variable with mattr_accessor :variable
    # set default for variable self.variable = "Foo"

    # mailer sender for password recovery
    mattr_accessor :mailer_sender
    self.mailer_sender = 'skrw@mail.com'

    # path after sign in
    mattr_accessor :after_sign_in_path
    self.after_sign_in_path = '/'

    # path after sign out
    mattr_accessor :after_sign_out_path
    self.after_sign_out_path = '/'

    # CSS base class for forms (disabled)
    # mattr_accessor :form_css_base_class
    # self.form_css_base_class = 'skrwf'

    # process uploaded files in background jobs (requires Redis and Sidekiq)
    mattr_accessor :process_uploads_in_background_job
    self.process_uploads_in_background_job = false

    # allowed upload mime-types
    mattr_accessor :allowed_upload_mime_types
    self.allowed_upload_mime_types = %W(image/jpg image/png image/gif video/quicktime video/mp4)

    # maximum upload file size
    mattr_accessor :max_upload_file_size
    self.max_upload_file_size = 200.megabytes

    # process image, video
    mattr_accessor :image_processor, :video_processor
    self.image_processor = false
    self.video_processor = false
  end

  # setup method for configuration
  # in myapp/config/initializers/skrw.rb
  def self.setup(&block)
    yield(self)
  end
end
