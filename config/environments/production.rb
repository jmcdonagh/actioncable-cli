# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# Common useful optionals commented out below.
Rails.application.configure do
  config.action_controller.perform_caching = true
  config.active_support.report_deprecations = false
  config.assets.compile = false
  config.consider_all_requests_local = false
  config.eager_load = true
  config.enable_reloading = false
  config.force_ssl = true
  config.i18n.fallbacks = true

  # rubocop:disable Style/BlockDelimiters
  # rubocop:disable Style/MultilineBlockChain
  config.logger = ActiveSupport::Logger.new(
    $stdout
  ).tap  { |logger|
    logger.formatter = Logger::Formatter.new
  }.then { |logger|
    ActiveSupport::TaggedLogging.new(logger)
  }
  # rubocop:enable Style/BlockDelimiters
  # rubocop:enable Style/MultilineBlockChain

  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
  config.log_tags = [:request_id]

  # Ensures that a master key has been made available in:
  # * ENV["RAILS_MASTER_KEY"]
  # * config/master.key
  # * an environment key such as config/credentials/production.key.
  #
  # This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = {
  #   exclude: ->(request) { request.path == "/up" }
  # }
  #
  # config.action_cable.allowed_request_origins = [
  #   "http://example.com",
  #   /http:\/\/example.*/,
  # ]
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.asset_host = "http://assets.example.com"
  # config.assets.css_compressor = :sass
  # config.assume_ssl = true
  # config.cache_store = :mem_cache_store
  # config.public_file_server.enabled = false
end
