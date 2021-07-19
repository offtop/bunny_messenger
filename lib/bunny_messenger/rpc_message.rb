class BunnyMessenger
  class RpcMessage < Message
    def initialize(payload, opts = {})
      super
      @opts = @opts.merge({ reply_to: reply_to })
    end

    def call
      trace_time "Message #{message_id} sent in" do
        exchange.publish(payload, opts)
      end
      
      reply_to_queue.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
        loop { sleep 1 }
      end
      puts 'Ok, finished'
    end

    # ReplyTo queue name
    def reply_to
      raise NotImplementedError
    end

    private

    def locked?
      @lock
    end

    def lock
      @lock = true
    end

    def unlock
      @lock = false
    end

    def reply_to_queue
      @queue = BunnyMessenger::QueueByName.call(reply_to)
    end

    def correlation_id
      @correlation_id = SecureRandom.hex(10)
    end
  end
end