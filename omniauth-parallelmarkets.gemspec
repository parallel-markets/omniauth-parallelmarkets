# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'omniauth-parallelmarkets/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-parallelmarkets'
  s.version     = OmniAuth::ParallelMarkets::VERSION
  s.authors     = ['Brian Muller']
  s.email       = ['bamuller@gmail.com']

  s.summary     = 'Parallel Markets OAuth strategy for OmniAuth'
  s.description = 'Parallel Markets OAuth strategy for OmniAuth.'
  s.homepage    = 'https://github.com/parallel-markets/omniauth-parallelmarkets'
  s.license     = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.start_with?('spec/') }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.2'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rubocop'
end
