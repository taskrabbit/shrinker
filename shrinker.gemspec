# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shrinker/version'

Gem::Specification.new do |gem|
  gem.name          = "shrinker"
  gem.version       = Shrinker::VERSION
  gem.authors       = ["jrichardlai"]
  gem.email         = ["jrichardlai@gmail.com"]
  gem.description   = %q{Find links in a text and shorten them}
  gem.summary       = %q{Find links in a text and shorten them}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
