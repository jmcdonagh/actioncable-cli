# frozen_string_literal: true

# rubocop:disable Rails/RakeEnvironment
desc 'Run Brakeman'
task :brakeman, :output_files do |_, args|
  require 'brakeman'

  files = args[:output_files].split if args[:output_files]
  Brakeman.run app_path: '.', output_files: files, print_report: true
end
# rubocop:enable Rails/RakeEnvironment
