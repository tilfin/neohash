
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "neo_hash/version"

Gem::Specification.new do |spec|
  spec.name          = "neohash"
  spec.version       = NeoHash::VERSION
  spec.authors       = ["Toshimitsu Takahashi"]
  spec.email         = ["toshi@tilfin.com"]

  spec.summary       = %q{Accessible Hash and attaching it to an Object}
  spec.description   = %q{Accessible Hash and attaching it to an Object}
  spec.homepage      = "https://github.com/tilfin/neohash"
  spec.license       = "MIT"

  spec.files         = Dir['[A-Z]*[^~]'] + Dir['lib/**/*.rb'] + ['.gitignore', 'LICENSE']
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
