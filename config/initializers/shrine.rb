require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/memory'

if Rails.env.test?
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type # determine the file's mime_type
Shrine.plugin :infer_extension, force: true # determine mime_type from file instead of filename
Shrine.plugin :store_dimensions, analyzer: :ruby_vips # store image dimensions (using libvips)
# TODO use variable analyzer to store dimensions (such as libvips)
Shrine.plugin :delete_promoted # delete file after promotion
Shrine.plugin :delete_raw unless (Rails.env.development? || Rails.env.test?) # delete raw file after upload / promotion
Shrine.plugin :remove_invalid # remove file if it's invalid
Shrine.plugin :versions # create versions (such as for responsive images or movie stills)
Shrine.plugin :processing # process uploaded files
Shrine.plugin :backgrounding # move files to background jobs (will have to be enabled in skrw.rb initializer)