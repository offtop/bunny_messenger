# frozen_string_literal: true

class BunnyMessenger
  # Basis class for consumer
  class Consumer
    attr_reader :queue

    include BunnyMessenger::Loggable

    def initialize(queue_name)
      @queue = BunnyMessenger::QueueByName.call(queue_name)
    end

    def perform(delivery_info, metadata, payload)
      raise NotImplementedError
    end

    def perform_on_fail(delivery_info, _metadata, _payload, _exception)
      delivery_info.channel.nack(delivery_info.delivery_tag, multiple, requeue)
    end

    def call
      queue.subscribe(block: true, manual_ack: true) do |delivery_info, metadata, payload|
        trace_time "Message #{metadata.message_id} processed in" do
          perform(delivery_info, metadata, payload)
          delivery_info.channel.ack(delivery_info.delivery_tag)
        end
      rescue StandardError => e
        trace_time "Message #{metadata.message_id} failed with #{e.message}" do
          perform_on_fail(delivery_info, metadata, payload, e)
        end
      end
    rescue Exception => e
      serve_exception(e)
      raise e
    end

    # Tihs is used to capture exceptions
    def serve_exception(_exception); end

    def multiple
      false
    end

    def requeue
      false
    end
  end
end
