# frozen_string_literal: true

class BunnyMessenger
  # Dynamic configuration for gem
  class Config
    class << self
      %i[auth_params connection_params web_host structure_file_path migrations_path
         logger_level].each do |m_name|
        define_method m_name do
          load_config
          BunnyMessenger.send(m_name) || send(['default', m_name].join('_'))
        end
      end

      def logger
        BunnyMessenger.logger || default_logger
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

        begin
          @config = YAML.load_file('config/bunny.yml')[environment]
          @config.each do |k, v|
            if v.is_a?(Hash)
              BunnyMessenger.send("#{k}=", v.transform_keys(&:to_sym))
            else
              BunnyMessenger.send("#{k}=", v)
            end
          end
        rescue Errno::ENOENT
          @config = {}
        end
      end

      def default_logger_level
        Logger::INFO
      end

      def default_logger
        return @default_logger if @default_logger

        @default_logger = Logger.new($stdout)
        @default_logger.level = logger_level
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
