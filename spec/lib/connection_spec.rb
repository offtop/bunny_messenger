# frozen_string_literal: true

describe BunnyMessenger::Connection do
  it { expect(described_class.instance).to be_a Singleton }
  it { expect(described_class.instance).to be_a Bunny::Session }
end
