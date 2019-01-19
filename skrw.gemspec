$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "skrw/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "skrw"
  spec.version     = '0.0.1'
  spec.authors     = ["Paul Bernhard"]
  spec.email       = ["mail@pbernhard.com"]
  # spec.homepage    = "N/A"
  spec.summary     = "Skrw - Simple admin engine with authentication, upload and form functionalities"
  spec.description = "Skrw - Simple admin engine with authentication, upload and form functionalities"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'rails', '~> 5.2.2'
  spec.add_dependency 'sass-rails', '~> 5.0', '>= 5.0.7' # scss compilation

  spec.add_dependency 'devise', '~> 4.5' # authentication of user

  spec.add_dependency 'shrine', '~> 2.14' # file uploading
  spec.add_dependency 'shrine-memory', '~> 0.3.0' # in-memory storage for faster upload tests
  spec.add_dependency 'image_processing', '~> 1.7', '>= 1.7.1' # image processing for uploads

  spec.add_dependency 'redis', '~> 4.1' # redis
  spec.add_dependency 'sidekiq', '~> 5.2', '>= 5.2.5' # background jobs

  spec.add_development_dependency 'pg'
end
