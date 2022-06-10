lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fluent/plugin/nais/version"

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-nais"
  spec.version       = Fluent::Plugin::Nais::VERSION
  spec.authors       = ["Terje Sannum"]
  spec.email         = ["terje.sannum@nav.no"]
  spec.homepage      = "https://github.com/nais/fluent-plugin-nais"
  spec.summary       = %q{Fluentd plugin for Nais}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'fluentd', '~> 1.2'
  spec.add_dependency 'nais-log-parser', '~> 0.43.0'

  spec.required_ruby_version = '>= 2.3.0'
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.metadata = {
    'github_repo' => 'ssh://github.com/nais/fluent-plugin-nais'
  }
end
