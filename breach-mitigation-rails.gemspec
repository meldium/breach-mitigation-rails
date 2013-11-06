# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'breach_mitigation/version'

Gem::Specification.new do |spec|
  spec.name          = "breach-mitigation-rails"
  spec.version       = BreachMitigation::VERSION
  spec.authors       = ["Bradley Buda"]
  spec.email         = ["bradleybuda@gmail.com"]
  spec.description   = %q{Mitigates the BREACH and CRIME attacks on TLS in Rails applications}
  spec.summary       = %q{Uses length-hiding and CSRF token masking to make it more difficult for an attacker to recover plaintext from HTTP responses. See README.md for details.}
  spec.homepage      = "https://github.com/meldium/breach-mitigation-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "active_support"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
