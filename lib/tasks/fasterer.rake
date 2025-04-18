# frozen_string_literal: true

desc 'Run Fasterer'
task fasterer: :environment do
  puts 'Running Fasterer...'
  sh 'bundle exec fasterer app lib spec'
end
