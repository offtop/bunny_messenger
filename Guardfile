# frozen_string_literal: true
guard :rspec, cmd: 'bundle exec rspec', notification: true, all_after_pass: true do
  watch('spec/spec_helper.rb')                        { 'spec' }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/bunny_messenger/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
end
