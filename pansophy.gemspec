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
  spec.description   = 'Pansophy allows different applications to share knowledge' \
                       'via a centralised remote repository'
  spec.homepage      = 'https://github.com/sealink/pansophy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'fog-aws', '>= 2', '< 4'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'adamantium'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coverage-kit'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry-byebug'
end
