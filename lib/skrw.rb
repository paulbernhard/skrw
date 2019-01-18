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
  end

  # setup method for configuration
  # in myapp/config/initializers/skrw.rb
  def self.setup(&block)
    yield(self)
  end
end
