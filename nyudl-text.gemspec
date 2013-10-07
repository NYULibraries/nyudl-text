# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nyudl/text/version'

Gem::Specification.new do |spec|
  spec.name          = "nyudl-text"
  spec.version       = Nyudl::Text::VERSION
  spec.authors       = ["Joseph Pawletko"]
  spec.email         = ["jgp@nyu.edu"]
  spec.description   = %q{NYU Digital Library Text Objects}
  spec.summary       = %q{Code for processing NYU Digital Library Text Objects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "simplecov"
  
  spec.add_dependency "aasm"
end
