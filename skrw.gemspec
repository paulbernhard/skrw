$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "skrw/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "skrw"
  spec.version     = Skrw::VERSION
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

  # spec.add_dependency 'rails', '~> 5.2.2'
  spec.add_dependency 'rails', '~> 6.0.0.rc1'
  spec.add_dependency 'sass-rails', '~> 5.0', '>= 5.0.7' # scss compilation
  spec.add_dependency 'jbuilder', '~> 2.8' # jbuilder for JSON responses

  spec.add_dependency 'devise', '~> 4.5' # authentication of user
  spec.add_dependency 'simple_form', '~> 4.1' # forms

  spec.add_development_dependency 'pg'
end
