# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_cable/engine'

# require "action_mailbox/engine"
# require "action_mailer/railtie"
# require "action_text/engine"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ActioncableCli
  # TODO: CHANGE THIS COMMENT ONCE YOU FORK!!!
  #
  # ActionCable CLI is a bare-bones CLI app that demonstrates how to run a
  # skinny Rails app that runs background jobs and shows the CLI its output.
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators.system_tests = nil
  end
end
