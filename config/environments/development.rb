# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.action_cable.disable_request_forgery_protection = true
  config.action_controller.raise_on_missing_callback_actions = true
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.assets.quiet = true
  config.cache_store = :memory_store
  config.consider_all_requests_local = true
  config.eager_load = false
  config.enable_reloading = true
  config.i18n.raise_on_missing_translations = true
  config.server_timing = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.enable_fragment_cache_logging = true
    config.action_controller.perform_caching = true

    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
end
