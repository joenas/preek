# -*- encoding: utf-8 -*-
require File.expand_path('../lib/preek/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["jonnev"]
  gem.email         = ["jonnev@bredband2.se"]
  gem.description   = %q{Gives the nice output to the reek}
  gem.summary       = %q{it reeks buts its pretty}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.executable    = 'preek'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "preek"
  gem.require_paths = ["lib"]
  gem.version       = Preek::VERSION
  gem.add_runtime_dependency "thor"
end
