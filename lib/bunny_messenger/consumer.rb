class BunnyMessenger
  class Consumer
    attr_reader :queue
    def initialize(queue_name)
      @queue = BunnyMessenger::QueueByName.(queue_name)
    end

    def perform(delivery_info, metadata, payload)
      raise NotImplementedError
    end

    def perform_on_fail(delivery_info, metadata, payload, exception); end

    def call
      queue.subscribe(block: true, manual_ack: true) do |delivery_info, metadata, payload|
        perform(delivery_info, metadata, payload)
        delivery_info.channel.ack(delivery_info.delivery_tag)
      rescue StandardError => exception
        perform_on_fail(delivery_info, metadata, payload, exception)
        delivery_info.channel.nack(delivery_info.delivery_tag)
      end
    end
  end
end