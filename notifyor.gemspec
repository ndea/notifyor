$:.push File.expand_path("../lib", __FILE__)

require "notifyor/version"

Gem::Specification.new do |s|
  s.name = "notifyor"
  s.version = Notifyor::VERSION

  s.authors = ["Erwin Schens"]
  s.email = ["erwin.schens@qurasoft.de"]
  s.homepage = "https://github.com/ndea/notifyer"
  s.summary = "Get realtime notifications on your desktop if something happens in your Rails app."
  s.description = "Notifyer creates growl notifications on your desktop if something happens in your Rails app."
  s.license = "MIT"
  s.executables   = ["notify_me"]
  s.require_paths = ["lib"]

  s.files = Dir["{app,config,db,lib,bin}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'redis'
  s.add_dependency 'connection_pool'
  s.add_dependency 'terminal-notifier'
  s.add_dependency 'net-ssh'
  s.add_dependency 'net-ssh-gateway'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec", "~> 3.4.0"
end
