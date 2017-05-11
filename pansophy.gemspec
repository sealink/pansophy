# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pansophy/version'

Gem::Specification.new do |spec|
  spec.name          = 'pansophy'
  spec.version       = Pansophy::VERSION
  spec.authors       = ['Alessandro Berardi']
  spec.email         = ['berardialessandro@gmail.com']

  spec.summary       = 'Information sharing via centralised repository'
  spec.description   = 'Pansophy allows different applications to share knowledge ' \
                       'via a centralised remote repository'
  spec.homepage      = 'https://github.com/sealink/pansophy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'fog-aws', '~> 1.3'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'anima', '~> 0.3'
  spec.add_dependency 'adamantium', '~> 0.2'
  spec.add_dependency 'facets', '~> 3.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'dotenv', '~> 2.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'coverage-kit'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rubocop', '~> 0.36'
  spec.add_development_dependency 'travis', '~> 1.8'
end
