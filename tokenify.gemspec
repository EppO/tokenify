# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tokenify/version'

Gem::Specification.new do |spec|
  spec.name          = "tokenify"
  spec.version       = Tokenify::VERSION
  spec.authors       = [ "Florent Monbillard" ]
  spec.email         = [ "f.monbillard@gmail.com" ]
  spec.description   = %q{tokenify is a utility class to generate and decrypt tokens using AES-256 encryption}
  spec.summary       = %q{Utility class to generate and decrypt tokens}
  spec.homepage      = "https://github.com/EppO/tokenify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "openssl"
  spec.add_dependency "base64"
end
