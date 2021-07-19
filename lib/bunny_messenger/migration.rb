# frozen_string_literal: true

class BunnyMessenger
  # Template for migrations
  class Migration
    include BunnyMessenger::Loggable

    def call
      start_time = Time.now
      log_info("#{version} Migration started #{self.class.name}")
      up && ::BunnyMessenger::Migrator.save
      duration = Time.now - start_time
      log_info("Migration completed #{self.class.name} in #{duration} seconds")
    end

    def up
      raise NotImplementedError
    end

    def version
      raise NotImplementedError
    end

    private

    def channel
      @channel ||= ::BunnyMessenger::Connection.instance.create_channel
    end

    def delete_exchange(name)
      ::BunnyMessenger::ExchangeByName.call(name).delete
    end

    def delete_queue(name)
      ::BunnyMessenger::QueueByName.call(name).delete
    end

    def create_queue(name, opts = {})
      ::Bunny::Queue.new(channel, name.to_s, opts)
    end

    def create_exchange(name, type, opts = {})
      ::Bunny::Exchange.new(channel, type, name.to_s, opts)
    end

    def create_binding(target, source, opts = {})
      target.bind(source, opts)
    end
  end
end
