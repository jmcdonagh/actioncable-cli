# frozen_string_literal: true

require 'bundler'
require 'bundler/audit/task'
require 'rake'
require 'reek/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

require_relative 'config/application'

Rails.application.load_tasks

Bundler::Audit::Task.new

Reek::Rake::Task.new do |t|
  t.source_files = '{app,lib,spec}/**/*'
  t.fail_on_error = false
end

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end

task default: %i[
  spec
  rubocop
  reek
  skunk
  fasterer
  brakeman
  yard
  bundle:audit:update
  bundle:audit:check
]
