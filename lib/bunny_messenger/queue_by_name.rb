# frozen_string_literal: true

class BunnyMessenger
  # Wrapper for Bunny queue to be able to find queue just by name
  class QueueByName
    class << self
      def call(name, channel = nil)
        q_dat = structure.dig(:queues)
                         .find { |x_hash| x_hash['name'] == name }
        raise "Queue not found with name #{name} in schema" unless q_dat

        new_queue = Bunny::Queue.new(
          channel || q_channel,
          name,
          q_dat.transform_keys(&:to_sym)
        )
        new_queue
      end

      private

      def q_channel
        @q_channel = BunnyMessenger::Connection.instance.create_channel
      end

      def structure
        @structure ||= YAML.load_file(BunnyMessenger::Config.structure_file_path)
      end
    end
  end
end
