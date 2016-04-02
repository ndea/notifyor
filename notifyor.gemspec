$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "notifyor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "notifyor"
  s.version = Notifyor::VERSION
  s.authors = ["Erwin Schens"]
  s.email = ["erwin.schens@qurasoft.de"]
  s.homepage = "https://github.com/ndea/notifyer"
  s.summary = "Get realtime notifications on your desktop if something happens in your Rails app."
  s.description = "Notifyer creates growl notifications on your desktop if something happens in your Rails app."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.6.0"
end
