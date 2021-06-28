# frozen_string_literal: true

class BunnyMessenger
  # Module for logging
  module Loggable
    def logger
      BunnyMessenger::Config.logger
    end

    def log_debug(string)
      logger.debug(string)
    end

    def log_info(string)
      logger.info(string)
    end

    def log_warn(string)
      logger.warn(string)
    end

    def log_error(string)
      logger.error(string)
    end

    def log_fatal(string)
      logger.fatal(string)
    end

    def trace_time description, &block
      start_time = Time.now
      data = yield
      log_info([
        description, 
        (Time.now - start_time).to_f.to_s, 
        's'
      ].join(' '))
      data
    end
  end
end
