# frozen_string_literal: true

class BunnyMessenger
  # Skeleton for outgoing message
  class Message
    include BunnyMessenger::Loggable
    attr_reader :payload
    attr_writer :content_type
    attr_accessor :routing_key

    def initialize(payload, opts = {})
      self.payload = payload
      @opts = opts
    end

    def content_type
      @content_type ||= 'application/json'
    end

    def call
      return if called?
      trace_time "Message #{message_id} sent in" do 
        exchange.publish(payload, opts)
      end
    end

    private

    def default_opts
      {
        routing_key: routing_key,
        persistent: true,
        content_type: 'application/json',
        mandatory: true,
        message_id: message_id
      }
    end

    def called?
      return @called if @called
      
      @called = true
      false
    end

    def message_id
      @message_id ||= SecureRandom.hex
    end

    def exchange
      raise NotImplementedError
      # Ensure Exchange is defined correctly here
      @exchange ||= BunnyMessenger::ExchangeByName.('exchange_name')

      @exchange
    end

    def payload=(payload)
      @payload = case payload
                 when String
                   payload
                 else
                   payload.to_json
                 end
    end

    def class_opts
      {}
    end

    def opts
      default_opts.merge.merge(class_opts).merge(@opts)
    end
  end
end
