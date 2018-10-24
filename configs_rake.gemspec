# frozen_string_literal: true

require_relative 'lib/configs_rake/version'

Gem::Specification.new do |spec|
	spec.name = 'configs_rake'

	spec.version = ConfigsRake::VERSION

	spec.summary = 'Check config files from Rake'

	spec.authors = ['Alexander Popov']

	spec.required_ruby_version = '~> 2.3'

	spec.add_runtime_dependency 'diffy', '~> 3.2'
	spec.add_runtime_dependency 'paint', '~> 2.0'
	spec.add_runtime_dependency 'rake_helpers', '~> 0.0'

	spec.add_development_dependency 'rubocop', '~> 0.59.2'
end
