# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fluent/plugin/nais/version"

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-nais"
  spec.version       = Fluent::Plugin::Nais::VERSION
  spec.authors       = ["Terje Sannum"]
  spec.email         = ["terje.sannum@nav.no"]

  spec.summary       = %q{Fluentd plugin for Nais}
  spec.homepage      = "https://github.com/nais/fluent-plugin-nais"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'fluentd', '~> 1.1'
  spec.add_dependency 'nais-log-parser', '>= 0.20.0'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
