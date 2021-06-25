# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)

require "bunny_messenger"
Gem::Specification.new do |s|
  s.name        = 'bunny_messenger'
  s.version     = BunnyMessenger::VERSION
  s.summary     = 'Hola!'
  s.description = 'Bunny Messenger gemt'
  s.authors     = ['Ivan']
  s.email       = 'ivan@srgh.tech'
  s.files = Dir['lib/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.md']
  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'bunny', '>= 2.18.0'
  s.add_runtime_dependency 'httparty', '>= 0.18.1'
  s.add_runtime_dependency 'rake', '>= 12'
  s.license = 'MIT'
end
