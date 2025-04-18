# frozen_string_literal: true

desc 'Run Skunk'
task skunk: :environment do
  puts 'Running Skunk...'
  sh 'bundle exec skunk app lib spec'
end
