# frozen_string_literal: true

require 'diffy'
require 'paint'

class ConfigsRake
	## Helper class for one config file
	class ConfigFile
		EXAMPLE_SUFFIX = '.example'

		def self.all_in(configs_dir)
			Dir[File.join(configs_dir, '**', "*#{EXAMPLE_SUFFIX}*")]
				.lazy.map do |example_filename|
					new(example_filename)
				end
		end

		attr_reader(
			:example_filename,
			:regular_filename,
			:example_basename,
			:regular_basename
		)

		def initialize(example_filename)
			@example_filename = example_filename
			@regular_filename = @example_filename.sub(EXAMPLE_SUFFIX, '')

			@example_basename = Paint[File.basename(@example_filename), :green, :bold]
			@regular_basename = Paint[File.basename(@regular_filename), :red, :bold]
		end

		def diff
			Diffy::Diff
				.new(regular_filename, example_filename, source: 'files', context: 3)
				.to_s(:color)
		end

		def replace_regular_file_with_example_file
			File.write regular_filename, File.read(example_filename)
		end

		def regular_file_outdated?
			File.mtime(example_filename) > File.mtime(regular_filename)
		end

		def warn_about_outdated
			<<~WARN
				#{example_basename} was modified after #{regular_basename}.

				```diff
				#{diff}
				```

			WARN
		end
	end
end
