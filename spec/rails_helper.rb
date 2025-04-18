# frozen_string_literal: true

# Prefer editing spec_helper instead of this file.
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('cannot run tests in production env!') if Rails.env.production?
require 'rspec/rails'

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
  config.include ActionCable::TestHelper, type: :channel
  config.include ActionController::TestCase::Behavior, type: :controller
  config.include Rails.application.routes.url_helpers
  config.infer_spec_type_from_file_location!
  config.use_active_record = false
end
