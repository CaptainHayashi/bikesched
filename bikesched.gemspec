# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './version'

Gem::Specification.new do |spec|
  spec.name          = "bikesched"
  spec.version       = Bikesched::VERSION
  spec.authors       = ["mattbw"]
  spec.email         = ["matt.windsor@ury.york.ac.uk"]
  spec.summary       = %q{Simple interface to the URY schedule}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end