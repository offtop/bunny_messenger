# frozen_string_literal: true

class BunnyMessenger
  # Basis class to manage structure
  # Preffered to be used over rake
  # add `load 'bunny_messenger/Rakefile'` to your Rakefile
  class Migrator
    extend BunnyMessenger::Loggable
    class << self
      def migrate
        Dir["./#{config.migrations_path}/*.rb"]
          .sort
          .each { |file| require file }
        migrations = ObjectSpace
                     .each_object(Class)
                     .select { |klass| klass < BunnyMessenger::Migration }
        migrations = migrations.map(&:new).sort_by(&:version).map(&:call)
      end

      def save
        FileUtils.mkdir_p('db') unless File.directory?('db')
        File.open(config.structure_file_path, 'w') do |file|
          file.write(
            { exchanges: dump_exchanges, queues: dump_queues,
              bindings: dump_bindings }.to_yaml
          )
        end
        log_info('Schema saved to file ' +
          File.expand_path(config.structure_file_path))
      end

      def load
        struct = YAML.load_file(config.structure_file_path)
        exchanges = {}
        queues = {}
        struct.dig(:exchanges).each do |x_hash|
          exchanges[x_hash['name']] =
            create_exchange(x_hash.transform_keys(&:to_sym))
        end
        struct.dig(:queues).each do |q_hash|
          queues[q_hash['name']] = create_queue(q_hash.transform_keys(&:to_sym))
        end
        struct.dig(:bindings).each do |b_hash|
          destination =
            { 'queue' => queues, 'exchange' => exchanges }
            .dig(b_hash['destination_type'], b_hash['destination'])
          source = exchanges.dig(b_hash['source'])
          destination.bind(source, routing_key: b_hash['routing_key'])
        end
        log_info('Loaded file ' + File.expand_path(config.structure_file_path))
      rescue Errno::ENOENT
        log_info("Cant access #{File.expand_path(config.structure_file_path)}")
      end

      private

      def dump_bindings
        HTTParty
          .get(config.web_host + '/api/bindings',
               basic_auth: config.auth_params)
          .parsed_response
          .reject { |b_hash| b_hash['source'].empty? }
      end

      def dump_queues
        filter_queues_params(
          HTTParty
            .get(config.web_host + '/api/queues',
                 basic_auth: config.auth_params)
            .parsed_response
        )
      end

      def dump_exchanges
        filter_exchanges_params(
          HTTParty
            .get(config.web_host + '/api/exchanges',
                 basic_auth: config.auth_params)
            .parsed_response
        )
      end

      def channel
        @channel ||= connection.create_channel
      end

      def config
        BunnyMessenger::Config
      end

      def create_exchange(x_hash)
        ::Bunny::Exchange.new(channel, x_hash[:type], x_hash[:name], x_hash)
      end

      def create_queue(q_hash)
        ::Bunny::Queue.new(channel, q_hash[:name], q_hash)
      end

      def connection
        @connection ||= BunnyMessenger::Connection.instance
      end

      def filter_queues_params(array)
        whitelist_keys = %w[ arguments auto_delete durable
                             exclusive name operator_policy policy type vhost]
        array.map do |q_hash|
          q_hash.select { |k, _v| whitelist_keys.include?(k) }
        end
      end

      def filter_exchanges_params(array)
        blacklist_keys = %w[message_stats user_who_performed_action]
        array.map do |x_hash|
          x_hash.reject do |k, _v|
            blacklist_keys.include?(k)
          end
        end
      end
    end
  end
end
