# frozen_string_literal: true

# config/initializers/redlock.rb
require 'redlock'

Rails.application.configure do
  config.redlock_client = Redlock::Client.new(
    [ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/7')],
    retry_count: 3,
    retry_delay: 200
  )
end
