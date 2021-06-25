# frozen_string_literal: true

class BunnyMessenger
  # Wrapper for rabbitmq connection
  class Connection < ::Bunny::Session
    include ::Singleton
    include BunnyMessenger::Loggable
    def initialize
      connection_string_or_opts = BunnyMessenger::Config.connection_params
      super(connection_string_or_opts) && start
      log_debug('Connection established')
      log_debug(connection_string_or_opts.to_s)
    end
  end
end
