# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-zinergia/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-zinergia"
  spec.version       = Omniauth::Zinergia::VERSION
  spec.authors       = ["Nicolás Hock Isaza"]
  spec.email         = ["nhocki@gmail.com"]
  spec.description   = %q{Omniauth strategy for Zinergia's Auth}
  spec.summary       = %q{Omniauth strategy for Zinergia's Auth}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency 'rack-test', '~> 0.6.2'
  spec.add_development_dependency 'webmock', '~> 1.13.0'

  spec.add_dependency "omniauth", "~> 1.9.0"
  spec.add_dependency "omniauth-oauth2", "~> 1.6.0"
end
