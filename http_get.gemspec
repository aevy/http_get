# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_get/version'

Gem::Specification.new do |spec|
  spec.name          = "http_get"
  spec.version       = HttpGet::VERSION
  spec.authors       = ["Erik Strömberg"]
  spec.email         = ["erik.stromberg@gmail.com"]
  spec.summary       = %q{Pikapika}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'httpclient'
  spec.add_dependency 'addressable'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
end
