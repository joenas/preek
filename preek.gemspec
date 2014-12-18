# -*- encoding: utf-8 -*-
require File.expand_path('../lib/preek/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jon Neverland"]
  gem.email         = ["jonwestin@gmail.com"]
  gem.description   = %q{Preek prints Ruby code smells in color, using Reek. }
  gem.summary       = %q{Code smells in color}
  gem.homepage      = "https://github.com/joenas/preek"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.executable    = 'preek'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "preek"
  gem.require_paths = ["lib"]
  gem.version       = Preek::VERSION
  gem.add_runtime_dependency "thor", "~> 0.18"
  gem.add_runtime_dependency "reek", "~> 1.5.1"
  gem.add_development_dependency "rspec", "~> 2.14.1"
  gem.add_development_dependency "rspec-given"
  gem.add_development_dependency "guard", "~> 2.3.0"
  gem.add_development_dependency "guard-rspec", "~> 4.2.5"
  gem.add_development_dependency 'coveralls'
end
