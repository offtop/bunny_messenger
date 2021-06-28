# frozen_string_literal: true

class BunnyMessenger
  # Dynamic configuration for gem
  class Config
    class << self
      def auth_params
        load_config
        BunnyMessenger.auth_params || default_auth_params
      end

      def connection_params
        load_config
        BunnyMessenger.connection_params || default_connection_params
      end

      def web_host
        load_config
        BunnyMessenger.web_host || default_web_host
      end

      def structure_file_path
        load_config
        BunnyMessenger.structure_file_path || default_structure_file_path
      end

      def migrations_path
        load_config
        BunnyMessenger.migrations_path || default_migrations_path
      end

      def logger
        load_config
        BunnyMessenger.logger || default_logger
      end

      def logger_level
        load_config
        BunnyMessenger.logger_level || default_logger_level
      end

      private

      def environment
        ENV['ENV'] ||
          ENV['RACK_ENV'] ||
          ENV['RAILS_ENV'] ||
          'development'
      end

      def load_config
        return if @config
        @config = YAML.load_file('config/bunny.yml')[environment]
        @config.each do |k,v|
          if v.is_a?(Hash)
            BunnyMessenger.send(k.to_s+'=', v.transform_keys(&:to_sym))
          else
            BunnyMessenger.send(k.to_s+'=', v)
          end
        end
      rescue Errno::ENOENT
        @config = {}
      end

      def default_logger_level
        Logger::DEBUG
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
