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

For all frontend styles and js functionalities you will need to include the npm package `@swrs/skrw-js` and load it in your application.

```bash
$ yarn add @swrs/skrw-js
```

```erb
# app/views/layouts/application.html.erb
<%= javascript_pack_tag "admin" if skrw_session? %>
<%= stylesheet_pack_tag "admin" if skrw_session? %>
```

```js
// app/javascript/packs/admin.js
import { Skrw } from "@swrs/skrw-js"

const skrw = Skrw.new()
skrw.start()
import "@swrs/skrw-js/src/styles/styles.scss"
```

The `@swrs/pshr-js` is **not precompiled**, so you will have to compile it. With webpacker this can be done easily be excluding all `@swrs/*` packages from babels's default list of ignored packages.

```js
// config/webpack/environment.js
// do not exclude @swrs/* packages with Babel to compile them
const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = /node_modules\/(?!(@swrs)\/).*/
```

_NOTE: To develop the @swrs/pshr-js package further, you can link the local package using `yarn link` and add the following setup to webpacker._

```js
// config/webpack.development.js

// disable resolving of symlinked (yarn link) paths
environment.config.set("resolve.symlinks", false)

// remove all @swrs/* packages from webpacker dev server ignrored paths
environment.config.set("devServer.watchOptions.ignored", /node_modules\/(?!@swrs).*/)
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

### User Bar / Dashboard
Include a dashboard for currently logged a user in your layout. Normally the dashboard would be placed in application.html.erb and would be accessible to the user from any page. You can set controls (or any content) that will appear in the dashboard site-wide or per view. Use like…

```erb
# application.html.erb
<%= skrw_user_bar do %>
  <%= link_to "Edit Site", edit_site_path %>
  <%= link_to "Posts Index", posts_path %>
  <%= link_to "New Post", new_post_path %>
  # etc.
<% end %>
```

By default the dashboard will only be displayed for logged in users. It can be restricted to admin users with `<%= skrw_user_bar(:admin) do %>…<% end %>`.

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
- Skrw displays flash messages using the `<%= user_bar %>` view helper. Flash messages are displayed dynamically for each ajax response which includes a `flash` object. The following request of a remote `form_with` to `PostsController` would get a json response with a `flash` object. The messages inside `flash` will be displayed dynamically in the user bar.

```erb
<%= form_with model: @post, local: false do |f| %>
  <%= f.label :title, Title %>
  <%= f.text_fields :title %>
  <%# … %>
<% end %>
```

… and a controller response including a flash object as json response…

```ruby
class PostsController < AdminController

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Created new post"
      render json: { flash.flash.to_hash }
    else
      render "new"
    end
  end
end
```

```json
flash: {
  success: "Something good happened"
}
```

### Skrw Form Builder

To use skrw's form functionalities build the forms in your templates using the `Skrw::FormBuilder`. All inherent form helpers stay available, some others are added…

```erb
<%= form_with model: @post, builder: Skrw::FormBuilder do |f| %>
  <%= f.base_errors %>

  <%= f.field :title, "Title" do %>
    <%= f.text_field :title %>
  <% end %>

  <%= f.field :body, "Text" do %>
    <%= f.text_area :body, data: { controller: "skrw-markdown" } %>
  <% end %>

  <%= f.submit "Save" %>
<% end %>
```

#### Errors
Use the `f.base_errors` helper to render all :base errors of a record. All errors related to a record's attribute can be rendered at the specific field using the `f.field(attribute, label, &block)` helper.

#### Field helper
Using the `f.field(attribute, label, &block)` helper the form builder will generate a wrapper with a label and automagical error display for the given `attribute`. The following field helpers…

```erb
<%= f.field :title, "Title" do %>
  <%= f.text_field :title %>
<% end %>
```

… renders…

```html
<div class="skrw-field">
  <label for="product_title">Title</label>
  <input type="text" value="Title" name="post[title]" id="post_title">
</div>
```

… after `f.object.errors.add(:title, "Something wrong with title…")` the field helper…

```erb
<%= f.field :title, "Title" do %>
  <%= f.text_field :title %>
<% end %>
```

… renders…

```html
<div class="skrw-field skrw-field--erroneous">
  <label for="product_title">Title</label>
  <input type="text" value="Title" name="post[title]" id="post_title">
  <div class="skrw-errors">
    <div>Something wrong with title…</div>
  </div>
</div>
```

#### Dynamic Nested Fields
Create nested fields with dynamic adding / removing of nested fields using the `f.dynamic_nested_fields(association, &block)` helper.

```ruby
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :all_blank
end
```

```erb
<%= form_with model: @post, builder: Skrw::FormBuilder do |f| %>
  # @post fields…

  <%= f.dynamic_fields_for :comments do |ff| %>
    <%= ff.text_field :body %>
    <%= ff.hidden_field :_destroy %>
  <% end %>
<% end %>
```

*Note: Don't forget to add `allow_destroy: true` and <%= f.hidden_field :_destroy %> to allow removal of nested records.*

## Etc
• TODO: add functionality to add, edit, remove users
• TODO: add password recovery dor users
• TODO: add custom skrw form helper

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
