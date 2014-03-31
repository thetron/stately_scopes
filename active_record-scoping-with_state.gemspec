# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/scoping/with_state/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record-scoping-with_state"
  spec.version       = ActiveRecord::Scoping::WithState::VERSION
  spec.authors       = ["Nicholas Bruning"]
  spec.email         = ["nicholas@bruning.com.au"]
  spec.summary       = %q{Automatically creates state query methods for each of your model's scopes.}
  spec.description   = %q{I've found that when developing Rails apps, I tend to almost always pair each scope with an instance method which returns a boolean indicating whether the object is included inside that scope.\n\nThis gem simply automatically creates that method for you. Nothing super fancy, and you might consider replacing the state methods with your own, more efficient, implementations - but it's great for early stages of development, or providing a comparative case for unit tests.}
  spec.homepage      = "http://github.com/thetron/active_record-scoping-with_state"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
