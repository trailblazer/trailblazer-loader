# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trailblazer/loader/version'

Gem::Specification.new do |spec|
  spec.name          = "trailblazer-loader"
  spec.version       = Trailblazer::Loader::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]
  spec.license       = "MIT"

  spec.summary       = %q{Loads all concepts files.}
  spec.description   = %q{Loads all Trailblazer concepts files at startup.}
  spec.homepage      = "http://trailblazer.to/gems/trailblazer/loader.html"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
