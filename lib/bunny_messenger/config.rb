# frozen_string_literal: true

class BunnyMessenger
  # Dynamic configuration for gem
  class Config
    class << self
      def auth_params
        BunnyMessenger.auth_params || default_auth_params
      end

      def connection_params
        BunnyMessenger.connection_params || default_connection_params
      end

      def web_host
        BunnyMessenger.web_host || default_web_host
      end

      def structure_file_path
        BunnyMessenger.structure_file_path || default_structure_file_path
      end

      def migrations_path
        BunnyMessenger.migrations_path || default_migrations_path
      end

      def logger
        BunnyMessenger.logger || default_logger
      end

      private

      def logger_level
        BunnyMessenger.logger_level || Logger::INFO
      end

      def default_logger
        return @default_logger if @default_logger

        @default_logger = Logger.new(STDOUT)
        @default_logger.level = Logger::INFO
        @default_logger
      end

      def default_migrations_path
        'db/bunny_messenger/migrations'
      end

      def default_structure_file_path
        'db/bunny_messenger/dump.yaml'
      end

      def default_auth_params
        { username: 'guest', password: 'guest' }
      end

      def default_connection_params
        {
          host: '127.0.0.1',
          port: 5672,
          ssl: false,
          vhost: '/',
          user: 'guest',
          pass: 'guest',
          heartbeat: :server,
          auth_mechanism: 'PLAIN'
        }
      end

      def default_web_host
        'http://localhost:15672'
      end
    end
  end
end
