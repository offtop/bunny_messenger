# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'bunny_messenger'
  s.version     = '0.1.8'
  s.summary     = 'Hola!'
  s.description = 'Bunny Messenger gemt'
  s.authors     = ['Ivan']
  s.email       = 'ivan@srgh.tech'
  s.files = Dir['lib/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.md']
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'bunny', '>= 2.18.0'
  s.add_runtime_dependency 'faraday', '>= 1.5.1'
  s.add_runtime_dependency 'faraday_middleware', '>=1.0.0'
  s.add_runtime_dependency 'rake', '>= 12'
  s.license = 'MIT'
end
