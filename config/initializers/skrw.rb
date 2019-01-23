# setup Skrw
# given values are default values

Skrw.setup do |config|

  # mailer sender for password recovery
  # config.mailer_sender = 'skrw@mail.com'

  # path after sign in
  # config.after_sign_in_path = '/'

  # path after sign out
  # config.after_sign_out_path = '/'

  # process uploaded files in background jobs (requires Redis and Sidekiq)
  # config.process_uploads_in_background_job = false

  # allowed upload mime-types
  # config.allowed_upload_mime_types = %W(image/jpg image/png image/gif video/quicktime video/mp4)

  # maximum upload file size
  # config.max_upload_file_size = 200.megabytes

  # enable processing for images, videos
  # create custom processor modules like app/uploaders/skrw/processors/image.rb (see README.md)
  # config.image_processor = false
  # config.video_processor = false

  # CSS base class for forms (disabled)
  # config.form_css_base_class = 'skrwf'
end