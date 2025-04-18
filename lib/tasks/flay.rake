# frozen_string_literal: true

desc 'Run Fasterer'
task flay: :environment do
  puts 'Running Fasterer...'
  sh 'bundle exec flay app lib spec'
end
