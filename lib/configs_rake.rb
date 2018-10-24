# frozen_string_literal: true

require 'rake_helpers'

require_relative 'configs_rake/config_file'

## Module with helper methods for Rake
class ConfigsRake
	include Rake::DSL
	include RakeHelpers

	def initialize(configs_dir: 'configs/', namespace_name: 'configs')
		@configs_dir = configs_dir

		namespace namespace_name do
			desc 'Check config files'
			task :check do
				check
			end
		end
	end

	private

	def check
		self.class::ConfigFile.all_in(@configs_dir).each do |config_file|
			if File.exist? config_file.regular_filename
				next unless config_file.regular_file_outdated?

				puts config_file.warn_about_outdated

				break if answer_for(config_file) == 'quit'
			else
				config_file.replace_regular_file_with_example_file
				edit_file config_file.regular_filename
			end
		end
	end

	def answer_for(config_file)
		case answer = question_for(config_file).answer
		when 'yes'
			edit_file config_file.regular_filename
		when 'replace'
			config_file.replace_regular_file_with_example_file
		when 'no'
			FileUtils.touch config_file.regular_filename
			puts 'File modified time updated'
		end

		answer
	end

	def question_for(config_file)
		Question.new(
			"Do you want to edit #{config_file.regular_basename} ?",
			%w[yes replace no quit]
		)
	end

	def edit_file(filename)
		sh "eval $EDITOR #{filename}"
	end
end
