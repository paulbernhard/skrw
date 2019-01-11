require 'skrw/engine'
require 'devise'

module Skrw
  # set config variables with defaults
  class << self
    # set variable with mattr_accessor :variable
    # set default for variable self.variable = "Foo"
    mattr_accessor :mailer_sender
    self.mailer_sender = "skrw@mail.com"
  end

  # setup method for configuration
  # in myapp/config/initializers/skrw.rb
  def self.setup(&block)
    yield(self)
  end
end
