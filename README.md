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
  - you can add context sensitive controls to the `user_bar` by setting `user_bar_controls` in yours views.
  ```ruby
  # in app/views/layouts/application.html.erb
  # set primary controls for all your views
  <%= user_bar_controls(:primary) do %>
    <%= link_to 'Add Post', new_post_path %>
  <% end %>

  # in app/views/posts/index.html.erb
  # set a secondary control for particular view
  <%= user_bar_controls(:secondary) do %>
    <%= link_to 'Add Post', new_post_path %>
  <% end %>
  ```
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

- JS functionalities (webpacker required!)
  ```bash
  $ yarn add @yaireo/tagify
  $ yarn add autosize
  ```
  copy the `app/javascript/controllers/skrw` directory to your `app/javascript/controllers` directory
- Devise helpers like `user_signed_in?` will be accessible / additionally there is `admin_signed_in?`
- create a user in console `Skrw::User.create!(email: 'mail@mail.com', passworD: 'password', password_confirmation: 'password')` (temporary until registration is finished)
- testing:
  - use `include Devise::Test::IntegrationHelpers` to sign_in / sign_out users in tests
  - use Skrw path helpers to test its routes such as `skrw.new_user_session_url`
  - place user fixtures in `skrw/users.yml` and assign with `@user = skrw_users(:user)` in tests
  - consider setting `config.cache_classes = false` in HostApp `test.rb` during Engine development
- mailer:
  - set production log level to WARN in order to avoid leaking recovery passwords to production.log in `config/environments/production.rb` with `config.log_level = :warn`

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

### Skrw form

#### Dynamic Nested Fields
To use dynamic nested fields, set up an association which accepts nested attributes on the parent model and `allow_destroy: true`. Create a partial with the inputs for the association's nested fields and a hiden field allow record deletion with `form.hidden_field :_destroy, value: false`. Implement the dynamic nested fields with the `form.dynamic_fields_for` helper.

```ruby
# app/models/product.rb
class Product < ApplicationRecord
  has_many :variants, dependent: :destroy
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank
end

# app/controllers/products_controller.rb
# allow nested attributes with an additional :_destroy attribute
def product_params
  params.require(:product).permit(variants_attributes: [:id, :title, :description, :price, :_destroy])
end

#### Dynamic Textareas
Use dynamic textareas by supplying `data-controller="skrw--textarea"` to your textarea.

```ruby
<%= skrw_form_for @something do |form| %>
  <%= form.input :text, as: :text, input_html: { data: { controller: "skrw--textarea" } } %><% end %>
<% end %>
```

# app/views/products/_variant_fields.html.erb
# NOTE: so far the form object in the fields partial has to be called 'form'
<%= form.input :title, label: "Option Name", placeholder: "English Edition", as: :string %>
<%= form.input :description, label: "Option Specifications", placeholder: "210 x 297 mm, 4C Offset, ...", as: :text %>
<%= form.input :price, label: "Price (€)", as: :decimal %>
<%= form.hidden_field :_destroy, value: false %>


# app/views/products/_form.html.erb
<%= skrw_form_for @product do |form| %>
  <%= form.error :base %>

  <%= form.dynamic_fields_for form, :variants, partial: "products/variant_fields" %>

  <%= form.buttons do %>
    <%= form.button :submit, "Save" %>
  <% end %>
<% end %>
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
