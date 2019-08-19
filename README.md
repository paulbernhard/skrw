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
  - User `<%= user_bar %>` in `application.html.erb` to include the admin bar for users. To include custom controls in the admin bar for the whole site, pass a block to `user_bar`:

  ```erb
  # app/views/layouts/application.html.erb
  <%= user_bar do %>
    <%= link_to "Edit Site", edit_site_path %>
    <%= link_to "Add Post", new_post_path %>
    # …
  <% end %>
  ```

  To add page-specific controls set `content_for(:skrw-controls)` in your page.

  ```erb
  # app/views/posts/edit/html.erb
  <% content_for(:skrw_controls) do %>
    <%= link_to "Delete Post", post_path(@post), method: :delete %>
  <% end %>

  # content_for(:skrw_controls) is concatenated by default to existing controls
  # In order to override previous controls set flush : true
  <% content_for(:skrw_controls, flush : true) do %>
    <%= link_to "Delete Post", post_path(@post), method: :delete %>
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

- user session


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

### Flashes
- Skrw displays flash messages dynamically for each page. To display flash messages after an ajax / json response insert a flash hash called `flash` in the json response:

```
# json response
flash: {
  success: "Something good happened",
  error: "Something bad happened"
}
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
