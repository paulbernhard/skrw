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
- include Skrw helpers `helper Skrw::Engine.helpers` in `ApplicationController`
- user `<%= user_bar %>` in `applicattion.html.erb` to include the administration bar for users
- Devise helpers like `user_signed_in?` will be accessible / additionally there is `admin_signed_in?`
- create a user in console `Skrw::User.create!(email: 'mail@mail.com', passworD: 'password', password_confirmation: 'password')` (temporary until registration is finished)
- testing: 
  - use `include Devise::Test::IntegrationHelpers` to sign_in / sign_out users in tests
  - use Skrw path helpers to test its routes such as `skrw.new_user_session_url`
  - place user fixtures in `skrw/users.yml` and assign with `@user = skrw_users(:user)` in tests

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
