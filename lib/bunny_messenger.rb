# frozen_string_literal: true

require 'bunny'
require 'logger'
require 'pathname'
require 'yaml'
require 'httparty'
require 'fileutils'
require 'singleton'
require 'json'

# Basis class for work with RabbitMQ
# - web_host -  http://localhost:15672/ - url for web admin
# - auth_params -  { username: , password:  } credentials for web admin panel
# - connection_params -  credentials for connection to rabbitmq
# - structure_file_path - path for schema to be stored
# - migrations_path - path to find migrations
# - logger - logger instance
# - logger_level - level of logger
class BunnyMessenger
  class << self
    attr_accessor :web_host,
                  :auth_params,
                  :connection_params,
                  :structure_file_path,
                  :migrations_path,
                  :logger,
                  :logger_level
  end
end
require 'bunny_messenger/loggable'
require 'bunny_messenger/config'
require 'bunny_messenger/connection'
require 'bunny_messenger/message'
require 'bunny_messenger/migrator'
require 'bunny_messenger/migration'
require 'bunny_messenger/exchange_by_name'
require 'bunny_messenger/queue_by_name'
require 'bunny_messenger/consumer'
