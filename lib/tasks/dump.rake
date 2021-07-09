# frozen_string_literal: true

require 'bunny_messenger'
namespace :bunny_messenger do
  desc 'Dump rabbitmq structure'
  task :save do
    BunnyMessenger::Migrator.save
  end
  desc 'Load saved structure, required reset env'
  task :flush do
    BunnyMessenger::Migrator.flush
  end
  task :load do
    BunnyMessenger::Migrator.load
  end
  desc 'Run all migrations'
  task :migrate do
    BunnyMessenger::Migrator.migrate
  end

  desc 'Create migration'
  task :create_migration, [:name] do |_task, args|
    path = BunnyMessenger::Config.migrations_path
    full_path = [path, args.name + '.rb'].join('/')
    klass_name = args.name.split('_').collect(&:capitalize).join
    raise 'Migration exists with this name' if File.file?(full_path)

    File.open(full_path, 'w') do |file|
      file.write(<<~STRING
        class #{klass_name} < BunnyMessenger::Migration
          def up
          end
          # This variable is needed for versioning
          def version
            #{Time.now.to_i}
          end
        end
      STRING
                )
    end
  end
end
