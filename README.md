# Skrw
Short description and motivation.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'skrw'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install skrw
```

- mount engine `mount Skrw::Engine, at: '/admin'`
- install migrations `rails skrw:install:migrations` and `rails db:migrate`
- user:
  - user `<%= user_bar %>` in `applicattion.html.erb` to include the administration bar for users
  - to `Skrw::User` with another model, override or add functionalities, create `models/skrw/user.rb` like:
  ```ruby
  module Skrw
    class User < ApplicationRecord
      include Skrw::Concerns::User

      # custom association
      has_many :posts

      # override methods
      def email
        "custom #{email}"
      end

      # add custom methods
      def superpower
        "PWNED!"
      end
    end
  end
  ```
- Devise helpers like `user_signed_in?` will be accessible / additionally there is `admin_signed_in?`
- create a user in console `Skrw::User.create!(email: 'mail@mail.com', passworD: 'password', password_confirmation: 'password')` (temporary until registration is finished)
- testing: 
  - use `include Devise::Test::IntegrationHelpers` to sign_in / sign_out users in tests
  - use Skrw path helpers to test its routes such as `skrw.new_user_session_url`
  - place user fixtures in `skrw/users.yml` and assign with `@user = skrw_users(:user)` in tests
  - consider setting `config.cache_classes = false` in HostApp `test.rb` during Engine development
- mailer:
  - set production log level to WARN in order to avoid leaking recovery passwords to production.log in `config/environments/production.rb` with `config.log_level = :warn`
- uploadable:
  - use the Skrw::Upload model for basic uploading
  - to use your own model hook `Skrw::Concerns::Uploadable` to your model and requires at least the fields `file_data` (json), `file_mime_type` (string), `promoted` (boolean, default: false). Running your model tests, include `Skrw::Concerns::UploadTest` into your model for basic functionality tests.
  ```ruby
  # app/models/my_upload.rb
  class MyUpload < ApplicationRecord
    include Skrw::Concerns::Uploadable
  end

  # test/models/my_upload_test.rb
  require 'test_helper'

  class MyUploadTest < ActiveSupport::TestCase
    include Skrw::Concerns::UploadTest
  end
  ```
  - default file processors require `libvips` installed on system
  - file type and size validation can be set with
  ```ruby
  config.allowed_upload_mime_types = %W(image/jpg image/png image/gif video/quicktime video/mp4)
  config.max_upload_file_size = 200.megabytes
  ```
  - file processing can be handled in background with `config.process_uploads_in_background_job = false` in `skrw.rb` initializer
  - default file processors are `Image`, `Video` and `File`. To define custom file processing create a processor like `image.rb` in `app/uploaders/processors` and override the `process method`. The expected output is a single file or a versions hash:
  ```ruby
  require 'image_processing/vips'

  module Skrw::Processors::Image

    def self.process(file)
      pipeline = ImageProcessing::Vips
        .source(file)
        .convert('jpg')

      wtf = pipeline.resize_to_limit!(20,20)
      wtf2 = pipeline.resize_to_limit!(10,10)

      { wtf: wtf, wtf2: wtf2 }
    end
  end
  ```
  - to use an own `MyUpload` model with `Uploadable` and the XHR create / destroy methods of `Skrw::UploadsController`, set routes for your controller and inherit from `Skrw::UploadsController`:
  ```ruby
  # add your resource to config/routes.rb
  resources :my_uploads, only: [:create, :update, :destroy], defaults: { format: :json }

  # inherit from Skrw::UploadsController
  # and override the upload resource with your model
  # optionally override 'upload_params' with additional attributes
  class MyUploadsController < Skrw::UploadsController

    # set resource anme
    def resource
      MyUpload
    end

    private

      # override upload_params
      def upload_params
        params.require(:my_upload).permit(:file, :uploadable_type, :uploadable_id, :caption)
      end
  end
  ```
  - In order to use your own form for custom attributes of your `MyUpload` copy Skrw's `uploads/_form.html.erb` to your views folder `app/views/skrw/uploads/_form.html.erb` and modify it

## Usage / Configuration

### Authentication
- you'll need to set up the default URL options for the Devise mailer in each environment, e.g. in `config/environments/development.rb`:
```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
- set sender of mailer in `skrw.rb` initializer:
```ruby
config.mailer_sender = "somebody@hollywood.com"
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
