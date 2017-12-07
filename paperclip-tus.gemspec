# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip/tus/version'

Gem::Specification.new do |spec|
  spec.name          = 'paperclip-tus'
  spec.version       = Paperclip::Tus::VERSION
  spec.authors       = ['Tomas Brazys']
  spec.email         = ['tomas.brazys@gmail.com']

  spec.summary       = 'tus server adapter for Paperclip'
  spec.homepage      = 'https://github.com/deees/paperclip-tus'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'

  spec.add_runtime_dependency 'paperclip', '>= 4.3'
  spec.add_runtime_dependency 'tus-server', '~> 2.0'
end
