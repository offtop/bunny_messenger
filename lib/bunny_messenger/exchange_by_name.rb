# frozen_string_literal: true

class BunnyMessenger
  # Wrapper for Bunny exchange to be able to find exchange just by name
  class ExchangeByName
    class << self
      def call(name, channel=nil)
        return known_exchanges[name.to_s] if known_exchanges[name.to_s]

        ex_dat = structure.dig(:exchanges)
                          .find { |x_hash| x_hash['name'] == name }
        raise "Exchange not found with name #{name} in schema" unless ex_dat
        new_exchange = Bunny::Exchange.new(
                        channel || ex_channel,
                        ex_dat['type'],
                        name,
                        ex_dat.transform_keys(&:to_sym))
        @known_exchanges[name.to_s] = new_exchange
        new_exchange
      end

      private

      def known_exchanges
        @known_exchanges ||= {}
        @known_exchanges
      end

      def ex_channel
        @ex_channel = BunnyMessenger::Connection.instance.create_channel
      end

      def structure
        @structure ||= YAML.load_file(BunnyMessenger::Config.structure_file_path)
      end
    end
  end
end
